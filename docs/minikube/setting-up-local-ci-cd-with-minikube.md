# Setting up a local CI/CD pipeline with Minikube

Running Tekton CI/CD pipelines in a local Kubernetes cluster with minikube, and then deploying applications to Google Cloud Run, is a sophisticated process.
Below is a step-by-step walkthrough:

### Prerequisites

- `minikube` and `kubectl` installed
- Google Cloud SDK installed
- Docker installed
- Google Cloud account

## Setup steps

### 1. Start `minikube`

Start a `minikube` instance with the required resources:

<details>
<summary>Start the cluster with 2 CPUs amd 2048 MB memory</summary>

```shell
minikube start --cpus=2 --memory=2048
```

</details>

<details>
<summary>Start the cluster with 4 CPUs; Set the Kubernetes version; Attach a volume</summary>

```shell
export LOCAL_SOURCE_PATH="$HOME/Documents/00_code-repos/java17-spring-gradle-bigquery-reference"
```

```shell
minikube start \
  --cpus 4 \
  --kubernetes-version v1.24.4 \
  --mount-string $LOCAL_SOURCE_PATH:/data --mount \
  --mount-string ~/.config/gcloud:/data/.config/gcloud --mount
```

</details>

Check that the `minikube` instance was successfully created using `kubectl`.

