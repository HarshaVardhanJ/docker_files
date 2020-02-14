# Building multi-architecture images with `docker buildx`

### `docker-buildx`

This is a tool builder to invoke `docker buildx` commands.

Arguments passed to this builder will be passed to `docker buildx` directly,
allowing callers to run [any `docker buildx` commands](https://docs.docker.com/engine/reference/commandline/buildx/). As of the moment of writing this README, there are no “official” images that serve this specific purpose, which is to help build images for multiple architectures by leveraging the `buildx` command in Docker. An example `cloudbuild.yaml` file is gievn below.



```yaml
# Sample cloudbuild.yaml file
steps:
	- name: hub.docker.com/harshavardhanj/docker-buildx
		args: ['build', '-t', '[IMAGE_NAME:IMAGE_TAG]', '-f', '/path/to/Dockerfile', '.']
```

### Examples

The following examples demonstrate build requests that use this builder:



#### Build and push a container image to Google Container Registry

This `cloudbuild.yaml` simply invokes `docker buildx` and pushes the resulting image.

```yaml
steps:
	- name: hub.docker.com/harshavardhanj/docker-buildx
		args: ['build', '-t', 'gcr.io/$PROJECT_ID/image_name', '.']
images: ['gcr.io/$PROJECT_ID/image_name']
```



As far as the functionality of`buildx` is concerned, it is primarily useful for building images with multi-architecture support with no additional changes to the `Dockerfile`.



#### Build and push a container image to Docker Hub

This requires a few more steps in order to authenticate with Docker Hub. The steps for this is taken from [GCP’s Cloud Build documentation](https://cloud.google.com/cloud-build/docs/interacting-with-dockerhub-images#pushing_images_to_docker_hub). The steps will be described in a cursory fashion. For more detailed information, navigate to the given link. 

The first stage consists of encrypting your Docker Hub credentials so it can be passed to Cloud Build in a secure manner.



The below `cloudbuild.yaml` is a good place to start:

```yaml
steps:
- name: "gcr.io/cloud-builders/docker"
	entrypoint: "bash"
	args: ["-c", "docker login --username=[DOCKER_USER_ID] --password=$$PASSWORD"]
	secretEnv: ["PASSWORD"]
- name: "gcr.io/cloud-builders/docker"
	args: ["build", "-t", "[DOCKER_USER_ID]/[IMAGE]:[TAG]", "."]
images: "[DOCKER_USER_ID]/[IMAGE]:[TAG]"
secrets:
- kmsKeyName: "projects/[PROJECT_ID]/locations/global/keyRings/[KEYRING-NAME]/cryptoKeys/[KEY-NAME]"
	secretEnv:
		PASSWORD: "[base64-encoded encrypted Dockerhub password]"
```

where

* `[DOCKER_USER_ID]` is your Docker Hub username.
* `[IMAGE]` is the name of the image you want to push to Docker Hub.
* `[TAG]` is the name of the tag associated with the image you would like to push.
* `[PROJECT_ID]` is your GCP project ID.
* `[KEYRING-NAME]` is the name of your key ring.
* `[KEY-NAME]` is the name of the key.
* `[base64-encoded encrypted Dockerhub password]` is your encyrpted password as a base64 encoded string.