# Explanation of Docker Login Shell Commands with GCP Service Account Key

This document describes shell commands used to authenticate Docker with Google Artifact Registry, using a GCP service account key.
This authentication allows Docker to `push` and `pull` images to and from a private Google Artifact Registry.
Here's a breakdown of each command:

## Common Elements

- **`docker login`**: This is the Docker command used to authenticate against a Docker registry.
- **`-u _json_key`**: Specifies the username for authentication.
  When logging into Google Artifact Registry, use `_json_key` to indicate that a JSON key file is being used for authentication.
- **`--password-stdin`**: Tells Docker to read the password from standard input (`stdin`), which is more secure than passing it directly through the command line.
- **Service Account Key File**: This JSON file (`tekton-pipeline-key.json`) contains the credentials of a GCP service account.
  It's used to authenticate with Google Cloud services securely.

## Command Breakdown

### 1. Using `cat` with Pipe (`|`)

```shell
cat /Users/admin/.config/gcloud/tekton-pipeline-key.json | docker login -u _json_key --password-stdin us-central1-docker.pkg.dev
```

- **`cat /Users/admin/.config/gcloud/tekton-pipeline-key.json`**: This portion of the command uses `cat` to read the contents of the service account key file.
- **`|` (pipe)**: This symbol is used to pass the output of the preceding command (`cat`) as input to the following command (`docker login`).
- **`us-central1-docker.pkg.dev`**: The hostname of the Google Artifact Registry, specifying the `us-central1` region.
  This is where Docker is being authenticated to push or pull images.

### 2. Redirecting Input (`<`)

```shell
docker login -u _json_key --password-stdin us-central1-docker.pkg.dev/${GCP_PROJECT_ID}/my-artifact-registry-repo < /Users/admin/.config/gcloud/tekton-pipeline-key.json
```

- **`< /Users/admin/.config/gcloud/tekton-pipeline-key.json`**: Instead of piping with `|`, this command uses input redirection `<` to provide the service account key as the password. The `<` symbol directs the contents of the file to the `docker login` command's stdin.
- **`us-central1-docker.pkg.dev/${GCP_PROJECT_ID}/my-artifact-registry-repo`**: This more specific path includes the project ID (`${GCP_PROJECT_ID}`) and the repository name (`my-artifact-registry-repo`), providing a clearer target for Docker authentication.

### 3. Using `cat` with Pipe and Specifying Protocol

```shell
cat /Users/admin/.config/gcloud/tekton-pipeline-key.json | docker login -u _json_key --password-stdin https://us-central1-docker.pkg.dev
```

- **`https://us-central1-docker.pkg.dev`**: Similar to the first command but explicitly specifies the `https` protocol.
  While typically not required (as Docker assumes `https`), it makes the secure nature of the connection explicit.

## Conclusion

These commands are essential for CI/CD pipelines and automated workflows that require Docker to interact with Google Artifact Registry.
By using a service account key for authentication, you can securely push to or pull images from your private Artifact Registry repositories within your GCP projects.
The use of `--password-stdin` and input redirection or piping (`<` or `|`) enhances security by avoiding the need to include sensitive information directly in the command line.
