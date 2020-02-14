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
    && apk add --no-cache --virtual .qemu \
      qemu \
      qemu-arm \
      qemu-img \
      qemu-i386 \
      qemu-modules \
      qemu-s390x \
      qemu-system-arm \
      qemu-system-aarch64 \
      qemu-system-i386 \
      qemu-system-ppc \
      qemu-system-sparc \
    # Downloading files for binfmt
    && wget https://github.com/computermouth/qemu-static-conf/archive/master.zip \
    # Extracting zip file
    && unzip *.zip \
    && mkdir -p /lib/binfmt.d \
    # Copy files to created directory
    && cp qemu-static-conf-master/*.conf /lib/binfmt.d/ \
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
      version="1.0"

