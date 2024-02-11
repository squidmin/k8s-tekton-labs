# Manually pushing an image to GCP Artifact Registry using the Docker CLI

Working with Docker involves various commands to manage images, containers, and more.
Specifically, when deploying applications to Google Cloud Platform (GCP), you'll frequently use `docker tag` and `docker push` commands to tag your Docker images and push them to Google Artifact Registry.

## `docker tag` command

The `docker tag` command assigns a new tag to an existing image, which is useful for versioning or specifying destinations like a registry.

### Syntax

```shell
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
```

- `SOURCE_IMAGE[:TAG]`: The existing image you want to tag. If no tag is specified, `latest` is assumed.
- `TARGET_IMAGE[:TAG]`: The repository name, optionally with a tag, where you want the image to be stored.
  This can include the registry path.

### Example

For an application tagged for Google Artifact Registry with the following parameters:

- Application name: `my-app`
- GCP project: `lift-with-your-legs-123456`
- Artifact Registry repository: `my-artifact-registry-repo`

```shell
docker tag \
  my-app \
  us-central1-docker.pkg.dev/lift-with-your-legs-123456/my-artifact-registry-repo/my-app:latest
```

Here, the image `my-app` is tagged for pushing to a GCP Artifact Registry located in `us-central1`, within the GCP project `lift-with-your-legs-123456`, and the repository `my-artifact-registry-repo`.
The tag `latest` is used to indicate the latest version of this image.

## `docker push` command

The `docker push` command uploads a tagged image to a Docker repository such as Docker Hub or Google Artifact Registry.

### Syntax

```shell
docker push NAME[:TAG]
```

- `NAME[:TAG]`: The name of the image, optionally with a tag, to push to the registry.
  If no tag is specified, `latest` is assumed.

### Example

Pushing the previously tagged image to Google Artifact Registry:

```shell
docker push \
  us-central1-docker.pkg.dev/lift-with-your-legs-123456/my-artifact-registry-repo/my-app:latest
```

This command uploads the image `my-app` with the tag latest to the specified Artifact Registry repository.
The registry is identified by its location (`us-central1`), GCP project ID (`lift-with-your-legs-123456`), and repository name (`my-artifact-registry-repo`).

## Conclusion

Using `docker tag` and `docker push` commands, developers can efficiently manage Docker images for deployment.
Tagging allows for clear versioning and organization of images, while pushing uploads the images to a registry for distribution and deployment.
When working with GCP, specifying the correct Artifact Registry path and project information is crucial for successful image management and deployment.
