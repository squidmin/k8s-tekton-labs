# Setting up a local Tekton CI/CD pipeline with `kind`

How to set up a local Tekton CI/CD pipeline for an application with the following technical specifications:

- _**Language**_: Java v17
- _**Framework**_: Spring Boot v3
- _**Build system**_: Gradle

Covers building, tagging, and pushing the container image to GCP Artifact Registry and then deploying it to Cloud Run.

### 1. Dockerize the Spring Boot application

Below is an example `Dockerfile` to get started:

```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY ./build/libs/*.jar app.jar

ENTRYPOINT ["java","-jar","/app.jar"]
```

Remember to adjust your `COPY` path based on where Gradle outputs your JAR file.

For a more elaborate `Dockerfile` example that is suited to the aforementioned technical specs, expand the below example:

<details>
<summary>Example Dockerfile</summary>

```dockerfile
# ---- Build Stage ----
FROM gradle:8.3-jdk17 AS build

# Set a volume point for temp to get a performance improvement
#VOLUME /tmp

### Build arguments ###
ARG JAR_FILE=build/libs/*.jar
ARG APP_DIR=/usr/local/app
ARG APP_PROFILE
ARG GCP_SA_KEY_PATH
ARG GCP_ADC_ACCESS_TOKEN
ARG GCP_DEFAULT_USER_PROJECT_ID
ARG GCP_DEFAULT_USER_DATASET
ARG GCP_DEFAULT_USER_TABLE
###

### Environment variables ###
# OS
ENV APP_DIR=${APP_DIR}
# JVM arguments.
ENV APP_PROFILE=${APP_PROFILE}
ENV GCP_SA_KEY_PATH=${GCP_SA_KEY_PATH}
ENV GCP_ADC_ACCESS_TOKEN=${GCP_ADC_ACCESS_TOKEN}
ENV GCP_DEFAULT_USER_PROJECT_ID=${GCP_DEFAULT_USER_PROJECT_ID}
ENV GCP_DEFAULT_USER_DATASET=${GCP_DEFAULT_USER_DATASET}
ENV GCP_DEFAULT_USER_TABLE=${GCP_DEFAULT_USER_TABLE}
###

# Set working directory
WORKDIR /app

# Copy the source code
COPY . .

# Build the application
RUN gradle clean bootJar

# ---- Run Stage ----
FROM openjdk:17-jdk-slim

# Set application port
EXPOSE 8080

# Set working directory
WORKDIR /app

# Copy the executable jar from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Run the application
CMD ["java", "-jar", "app.jar"]
```

</details>

### 2. Set up Tekton on `kind`:

Create the Kubernetes cluster:

```shell
kind create cluster --name tekton-cluster
```

<details>
<summary>Note: Deleting and re-creating the cluster</summary>

If you need to delete and re-create the cluster, you can first run the below command to perform deletion:

```shell
kind delete cluster --name tekton-cluster
```

then:

```shell
kind create cluster --name tekton-cluster
```

</details>

Use the cluster with:

```shell
kubectl cluster-info --context kind-tekton-cluster
```

Install Tekton Pipelines:

```shell
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

Monitor the Tekton pipelines installation:

```shell
kubectl get pods --namespace tekton-pipelines --watch
```

Install tasks:

```shell
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml
kubectl apply -f https://api.hub.tekton.dev/v1/resource/tekton/task/kaniko/0.6/raw
```

### 3. Define the Tekton Tasks and Pipeline

1. **Setup access to GCP**:
   
   First, set up a _Kubernetes secret_ with your GCP service account credentials.

   The GCP service account credentials are required in order to authenticate with _GCP Artifact Registry_.

   For the creation of a _Kubernetes secret_, the data has to be base64 encoded.
   This repo includes a utility script to automate that:

   ```shell
   chmod +x ./scripts/generate_gcp_service_account_secret.py
   ```

   ```shell
   python3 ./scripts/generate_gcp_service_account_secret.py /path/to/your-service-account-key.json
   ```

   e.g.,

   ```shell
   python3 ./scripts/generate_gcp_service_account_secret.py ~/.config/gcloud/tekton-pipeline-key.json
   ```
   
   A file called `gcp-service-account-secret.yaml` will be generated and placed in the `crds/Secrets` directory.
   This is the _Kubernetes secret_. In the next step, it will be added to the `tekton-cluster` (created in **2. Set up Tekton on `kind`**) via the `kubectl` CLI.
   
### 4. Apply configurations to `tekton-cluster`

Firstly, make sure your `kubectl` context is pointing to your `kind` cluster named `tekton-cluster`:

```shell
kubectl cluster-info --context kind-tekton-cluster
```

And create the Kubernetes secret(s) in the `tekton-pipeline` cluster:

```shell
kubectl create secret generic docker-config --from-file=config.json=./crds/Secrets/config.json
```

```shell
# Bind the Service Account to Required Roles
kubectl create clusterrolebinding tekton-pipeline-admin --clusterrole=cluster-admin --serviceaccount=default:tekton-pipeline
```

Now, apply the Tekton tasks, pipelines, and other configurations:

```shell
# Apply the persistent volume claims
kubectl apply -f crds/PersistentVolumeClaims/pvc.yaml

# Apply the Tekton pipeline service account
kubectl apply -f crds/ServiceAccounts/

# Apply the GCP service account secret
kubectl apply -f crds/Secrets/gcp-service-account-secret.yaml

# Apply the Tekton Task
kubectl apply -f crds/Tasks/git-clone-build-push-task.yaml

# Apply the Tekton Pipeline
kubectl apply -f crds/Pipelines/spring-boot-cicd-pipeline.yaml
```

### 5. Start the Tekton Pipeline

```shell
kubectl create --filename crds/PipelineRuns/spring-boot-cicd-pipeline-run.yaml
```

You can also use the `tkn` CLI tool for Tekton to start the pipeline and interact with it:

```shell
tkn pipeline start spring-boot-cicd-pipeline \
  --param=pathToDockerFile="./Dockerfile" \
  --param=pathToContext="." \
  --param=imageUrl="us-central1-docker.pkg.dev/lofty-root-378503/lofty-root-docker-test/java17-spring-gradle-bigquery-reference" \
  --param=imageTag="latest" \
  --showlog
```

Here:

- `spring-boot-cicd-pipeline` is the name of the pipeline you want to run.
- The parameters `pathToDockerFile`, `pathToContext`, `imageUrl`, and `imageTag` are passed to the pipeline.
  Make sure to adjust the placeholders as per your configuration.

### 6. View the logs

With the `--showlog` flag in the `tkn pipeline start` command, you'll be able to see the logs directly as the pipeline runs.

However, if you need to check the logs of a specific task run or after the pipeline has completed, use:

```shell
# List the pipeline runs
tkn pipelinerun list

# Get the logs of a specific pipeline run
tkn pipelinerun logs build-and-deploy-pipeline-run-645hl -f
```

Replace `pipeline-run` with the name of the pipeline run you want to view the logs for, e.g.:

```shell
tkn pipelinerun logs build-and-push-pipelinerun-pjd48 -f
```


