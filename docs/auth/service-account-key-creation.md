# Service account key creation

Automating the creation of a Kubernetes secret involves scripting the sequence of commands required.
Here's a basic outline to automate the creation of the gcp-service-account secret using `kubectl`:

### 1. Download the Service Account Key from GCP

Assuming you've already created a service account on Google Cloud, you can use the `gcloud` CLI to create and download its key:

```shell
gcloud iam service-accounts keys create ~/path-to-save-key/your-service-account-key.json \
  --iam-account=SERVICE_ACCOUNT_NAME@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

e.g.,

```shell
gcloud iam service-accounts keys create ~/.config/gcloud/tekton-pipeline-key.json \
  --iam-account=tekton-pipeline@lofty-root-378503.iam.gserviceaccount.com"
```

### 2. Encode the Service Account Key

For the creation of a Kubernetes secret, the data has to be base64 encoded.
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

### 3. Echo the key string

```shell
echo -n "_json_key:$(cat /path/to/your-service-account-key.json)" | base64
```

e.g.,

```shell
echo -n "_json_key:$(cat ~/.config/gcloud/tekton-pipeline-key.json)" | base64
```
