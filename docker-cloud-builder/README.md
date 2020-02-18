# Building multi-architecture images with `docker buildx`

### `docker-buildx`

This is a tool builder to invoke `docker buildx` commands.

Arguments passed to this builder will be passed to `docker buildx` directly,
allowing callers to run [any `docker buildx` commands](https://docs.docker.com/engine/reference/commandline/buildx/). As of the moment of writing this README, there are no “official” images that serve this specific purpose, which is to help build images for multiple architectures by leveraging the `buildx` command in Docker. An example `cloudbuild.yaml` file is given below which is to be used with Cloud Build on Google Cloud Platform for automating builds.



```yaml
# Sample cloudbuild.yaml file
steps:
	- name: 'harshavardhanj/docker-buildx:latest'
		args: ['build', '-t', '[IMAGE_NAME:IMAGE_TAG]', '-f', '/path/to/Dockerfile', '.']
```

### Examples

The following examples demonstrate build requests that use this builder:



#### Build and push a container image to Google Container Registry

This `cloudbuild.yaml` simply invokes `docker buildx` and pushes the resulting image to GCR.

```yaml
steps:
	- name: 'harshavardhanj/docker-buildx:latest'
		args: ['build', '-t', 'gcr.io/$PROJECT_ID/image_name', '.']
images: ['gcr.io/$PROJECT_ID/image_name']
```



As far as the functionality of`buildx` is concerned, it is primarily useful for building images with multi-architecture support with no additional changes to the `Dockerfile`.



#### Build and push a container image to Docker Hub

##### Using GCP Key-Management Service(KMS)

This requires a few more steps in order to authenticate with Docker Hub. The steps for this is taken from [GCP’s Cloud Build documentation](https://cloud.google.com/cloud-build/docs/interacting-with-dockerhub-images#pushing_images_to_docker_hub). For more detailed information, navigate to the given link. 

The first stage consists of encrypting your Docker Hub credentials so it can be passed to Cloud Build in a secure manner. Then, the required information is provided to Cloud Build via the `cloudbuild.yaml` file.

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

##### Using GCP Secrets Manager

Common to both methods, it is recommended to create *access tokens* on Docker Hub. This way, your account password will not be exposed, and you can *create* and *revoke* access tokens any time you wish. 

Then, you will need to enable the Secrets Manager API on GCP. The steps to set up Secrets Manager can be found [here](https://cloud.google.com/secret-manager/docs/quickstart). Once the API has been enabled, create two new secrets : one for the Docker Hub username, and other for the Docker Hub Access Token.

Once you’ve created the secrets, grant the Cloud Build service account access to those two secrets. Refer to [this page](https://cloud.google.com/cloud-build/docs/securing-builds/use-encrypted-secrets-credentials#grant_the_service_account_access_to_the_cryptokey) for instructions on how to grant access to the service account. That link provides instructions on how to grant access to CryptoKey, but the steps are similar for Secrets Manager. Once permission has been granted to Cloud Build, the `cloudbuild.yaml` file and other files required by it can be created.

Given below is the `cloudbuild.yaml` file that I use for building images on Cloud Build and pushing the built images to Docker Hub.

```yaml
steps:
  # Get the Docker Hub user ID and access token and save each of them to files
  # accessible to the succeeding steps
  - name: 'gcr.io/cloud-builders/gcloud'
    entrypoint: "bash"
    args: ["./docker-cloud-builder/getCredentials.sh"]

  # Log in to Docker Hub using the credentials obtained in the previous steps
  - name: 'gcr.io/cloud-builders/docker'
    entrypoint: "bash"
    args: ["-c", "docker login --username=$(cat ./UserID) --password=$(cat ./AccessToken)"]

  # Build the container image using and push it to Docker Hub
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'build'
      - '-t'
      - 'harshavardhanj/docker-buildx:latest'
      - '-f'
      - './docker-cloud-builder/Dockerfile'
      - './docker-cloud-builder/.'
  # Pull buildx image from Docker Hub and build 'buildx' image with multi-arch support
  - name: 'harshavardhanj/docker-buildx:latest'
    args:
      - 'build'
      - '-t'
      - 'harshavardhanj/docker-buildx:latest'
      - '--platform'
      - 'linux/amd64,linux/arm64,linux/386,linux/arm/v7,linux/arm/v6'
      - '-f'
      - './docker-cloud-builder/Dockerfile'
      - '--push'
      - './docker-cloud-builder/.'
```



The `getCredentials.sh` script file :

```sh
#!/usr/bin/env sh
#
#: Title        : getCredentials.sh
#: Date         : 17-Feb-2020
#: Author       : "Harsha Vardhan J" <vardhanharshaj@gmail.com>
#: Version      : 0.1
#: Description  : Script which is used to get credentials by
#                 Cloud Build in order to log in to Docker Hub.
#: Options      : None
#: Usage        : This script is to be used in GCP Cloud Build.
################


# Wrapper function around the gcloud command used to access secrets
getCreds() {

	# If two arguments are provided to the script and
	# if the second argument is not an empty string
  if [[ $# -eq 2 && -n ${2} ]] ; then
  	# 'gcloud' command used to access secrets
    gcloud beta secrets versions access ${1} --secret="${2}"
  else
    exit 1
  fi

}

# Calling the 'getCreds' function and providing the version
# of the secret and secret name
getCreds 1 DockerHubUserID > ./UserID
getCreds 1 DockerHubAccessToken > ./AccessToken

# End of script
```

The only things that you will need to change are the image tags and the paths to the Dockerfile given in the last two steps of the `cloudbuild.yaml` file. A fairly generic `cloudbuild.yaml` file is given below which can be used as a template in order to build multi-architecture images. The first two steps remain the same as they deal with

1. Obtaining the login credentials to Docker Hub.
2. Logging in to Docker Hub using credentials obtained in the previous step.

Depending on where you place the `getCredentials.sh` file in your repository, you may need to modify the `args:` value in the first step. The third step will be the one that will need to be modified as per your needs.

```yaml
steps:
  # Get the Docker Hub user ID and access token and save each of them to files
  # accessible to the succeeding steps
  - name: 'gcr.io/cloud-builders/gcloud'
    entrypoint: "bash"
    args: ["./path/to/getCredentials.sh/from/repo/root"]

  # Log in to Docker Hub using the credentials obtained in the previous steps
  - name: 'gcr.io/cloud-builders/docker'
    entrypoint: "bash"
    args: ["-c", "docker login --username=$(cat ./UserID) --password=$(cat ./AccessToken)"]

  # Pull buildx image from Docker Hub and build with multi-arch support
  - name: 'harshavardhanj/docker-buildx:latest'
    args:
      - 'build'
      - '-t'
      - '[dockerHubUsername]/[imageName]:[imageTag]'
      - '-t'
      - '[dockerHubUsername]/[imageName]:[extraImageTag]'
      - '--platform'
      - 'linux/amd64,linux/arm64,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6'
      - '-f'
      - './path/to/Dockerfile/from/repo/root'
      - '--push'
      - './path/to/Dockerfile/directory/.'
```

The arguments to the `--platform` flag can be changed if needed. At times, building for `s390x` or `386` platform results in error for some images. If you encounter any such errors, which will be visible in the build logs, remove the offending architecture in which the error was encountered and build the image.

Now, using this setup multiple triggers can be created on Cloud Build to build and push multi-architecture images to Docker Hub and/or GCR.