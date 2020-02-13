# Dockerfile for creating an Alpine Linux image which is used
# to build Docker images with multi-arch support by using the
# `docker buildx` command.

# Starting with the base image of the latest version of Alpine Linux
FROM alpine:latest

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
    && wget https://github.com/docker/buildx/releases/download/v0.3.1/buildx-v0.3.1.linux-amd64 \
    && mv buildx-v0.3.1.linux-amd64 /usr/bin/docker-buildx \
    # Setting execute permission on the `buildx` executable
    && chmod a+x /usr/bin/docker-buildx

# Run as user
# (run as root for now. Once the image works as intended, create a new user and switch to that)
USER root

# Copying the 'entrypoint' script that will help configure 'docker-buildx'
COPY ./entrypoint.sh /usr/bin/

# Run the `docker build` command
#ENTRYPOINT ["sh", "-c", "docker-buildx create --use --name multiarch-builder"]
ENTRYPOINT ["entrypoint.sh"]

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      version="1.0"

