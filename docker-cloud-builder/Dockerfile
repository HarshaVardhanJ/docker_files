# Dockerfile for creating an Alpine Linux image which is used
# to build Docker images with multi-arch support by using the
# `docker buildx` command.

# Starting with the base image of the latest version of Alpine Linux
FROM alpine:latest

# Version number of `docker buildx`
ARG buildxVersion=0.3.1

# Setting working directory to '/'
WORKDIR /

# System call signal which will be sent to the container to exit
STOPSIGNAL SIGTERM

# Run the following commands
    # Adding the 'Community' repository which contains the 'Docker' package
RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories \
    # Updating package index
    && apk update \
    # Upgrading packages
    && apk upgrade -U \
    # Installing Docker
    && apk add --no-cache docker \
    # Setting environment variable for enabling experimental features in Docker
    && export DOCKER_CLI_EXPERIMENTAL=1 \
    # Downloading `buildx` binary release
    && wget https://github.com/docker/buildx/releases/download/v${buildxVersion}/buildx-v${buildxVersion}.linux-amd64 \
    && mv buildx-v${buildxVersion}.linux-amd64 /usr/bin/docker-buildx \
    # Setting execute permission on the `buildx` executable
    && chmod a+x /usr/bin/docker-buildx

# Run as user
# (run as root for now. Once the image works as intended, create a new user and switch to that)
USER root

# Copying the 'entrypoint' script that will help configure 'docker-buildx'
COPY ./entrypoint.sh /usr/bin/

# Run the `docker build` command
ENTRYPOINT ["entrypoint.sh"]

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      dockerfile.github.page="https://github.com/HarshaVardhanJ/docker_files\
/blob/master/docker-cloud-builder/Dockerfile"
      description="This Dockerfile creates an image of Docker with support for \
`buildx` added. This way, images can be built for multiple architectures. The \
suggested way to use this image is with GCP Cloud Build via a `cloudbuild.yaml` \
file in which this image will need to be invoked as a Cloud Builder. The \
arguments to the Cloud Builder will the same as the argument to the `buildx` \
executable. Start the arguments with 'build -f [DOCKERFILE] [BUILD-CONTEXT]. \
Check the sample `cloudbuild.yaml` file in this directory for an example of \
how this image is to be used in a `cloudbuild.yaml` file."
      version="1.0"

