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
    # Checking if `docker buildx` command works
#    && ./docker-buildx ls \
#    # Creating a new builder
#    && ./docker-buildx create --name multiarch-builder \
#    # Bootstrapping the builder
#    && ./docker-buildx inspect --bootstrap \
#    # Switching to the new builder
#    && ./docker-buildx use multiarch-builder

# Run as user
# (run as root for now. Once the image works as intended, create a new user and switch to that)
USER root

# Run the `docker build` command
ENTRYPOINT ["docker-buildx"]
#ENTRYPOINT ["docker-buildx create --name multiarch-builder", "&&", "./docker-buildx inspect --bootstrap", "&&", "./docker-buildx use multiarch-builder", "&&", "./docker-buildx"]
#ENTRYPOINT ["docker-buildx create --name multiarch-builder", "&&", "docker-buildx inspect --bootstrap", "&&", "docker-buildx use multiarch-builder"]

# Print out the builder being used
CMD ["create"]

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      version="1.0"

