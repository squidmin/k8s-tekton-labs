# Configure GCP Artifact Registry to work with Tekton Pipelines for CI/CD

These commands are part of a process for configuring a Google Cloud Platform (GCP) environment to work with Tekton Pipelines for CI/CD, specifically for publishing container images to Google Artifact Registry.

### 1. Creating a Docker Repository in Google Artifact Registry

```shell
gcloud artifacts repositories create REPOSITORY_NAME \
  --repository-format=docker \
  --location=us-central1 \
  --description="Test Docker repository"
```

Replace `REPOSITORY_NAME` with the name of your Artifact Registry repository:

```shell
gcloud artifacts repositories create my-artifact-registry-repo \
  --repository-format=docker \
  --location=us-central1 \
  --description="Test Docker repository"
```

This command creates a new Docker repository in Google Artifact Registry.
The repository is created in the `us-central1` region and is described as a "Test Docker repository".
This repository will be used to store Docker images.

### 2. Creating a Kubernetes Service Account

```shell
kubectl create serviceaccount SERVICE_ACCOUNT
```

Replace `SERVICE_ACCOUNT` with the name of your Kubernetes service account:

```shell
kubectl create serviceaccount tekton-sa
```

This command creates a new Kubernetes service account in the current Kubernetes namespace.
Tekton pipelines use this service account for running pipeline tasks which interact with the GCP resources.

### 3. Creating a GCP Service Account

```shell
gcloud iam service-accounts create SERVICE_ACCOUNT
```

Replace `SERVICE_ACCOUNT` with the name of your GCP service account:

```shell
gcloud iam service-accounts create gcp-tekton-sa
```

This command creates a new GCP service account named `gcp-tekton-sa`.
This service account is used to authenticate and authorize GCP operations performed by Tekton tasks / pipelines.

### 4. Granting Repository Access to the GCP Service Account

```shell
gcloud artifacts repositories add-iam-policy-binding my-artifact-registry-repo \
  --location us-central1 \
  --member=serviceAccount:gcp-tekton-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
  --role=roles/artifactregistry.reader \
  --role=roles/artifactregistry.writer
```

This command grants the `gcp-tekton-sa` service account permission to read from and write to the `my-artifact-registry-repo` Docker repository in the Artifact Registry.
It does this by binding two roles to the service account: `roles/artifactregistry.reader` and `roles/artifactregistry.writer`.

### 5. Annotating the Kubernetes Service Account with the GCP Service Account

```shell
kubectl annotate serviceaccount \
  tekton-sa \
  iam.gke.io/gcp-service-account=gcp-tekton-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com
```

This command annotates the Kubernetes service account (`tekton-sa`) with the GCP service account (`gcp-tekton-sa@GCP_PROJECT_ID.iam.gserviceaccount.com`).
This annotation is used by **Workload Identity** to link the Kubernetes service account to the GCP service account, allowing the Tekton tasks running under the Kubernetes service account to authenticate as the GCP service account.

### 6. Binding the GCP Service Account to the Kubernetes Service Account

```shell
gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:${GCP_PROJECT_ID}.svc.id.goog[default/tekton-sa]" \
  gcp-tekton-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com
```

This final command grants the `gcp-tekton-sa` service account the `roles/iam.workloadIdentityUser` role for the `tekton-sa` Kubernetes service account within the `default` namespace.
This step is crucial for enabling **Workload Identity**, a GCP service that allows Kubernetes service accounts to act as GCP service accounts, providing a more secure and manageable way to access GCP resources from GKE (Google Kubernetes Engine).

In summary, these commands set up a secure and authenticated bridge between Tekton running in Kubernetes and GCP services, specifically for publishing container images to a GCP Artifact Registry repository.
This setup uses **Workload Identity** to securely manage and use GCP credentials within CI/CD pipelines.
