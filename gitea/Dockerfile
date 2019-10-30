# Dockerfile for creating a container that runs Gitea

# Start with golang image as builder step
FROM golang:alpine as gitea-build

# Install dependencies for go
RUN apk add --no-cache --virtual .go-deps \
      gcc \
      git \
      make \
      musl-dev

# Environment variables
ENV GOPATH="/go"
ENV SRC_DIR="${GOPATH}/src/code.gitea.io/gitea"

# Getting the source code for Gitea
RUN go get -d -u code.gitea.io/gitea

# Changing working directory
WORKDIR "$SRC_DIR"

# Arguments for build options
ARG BUILD_TAGS="bindata sqlite sqlite_unlock_notify"

# Building Gitea
RUN TAGS="${BUILD_TAGS}" make generate build

# Start with Alpine Linux as base image
FROM alpine:latest

# Copy the Gitea binary from the builder step
COPY --from=gitea-build /go/src/code.gitea.io/gitea/gitea /usr/local/bin/gitea

# Install dependencies for Gitea
RUN apk add --no-cache --virtual .gitea-deps \
	    linux-pam \
	    bash \
	    git \
	    sqlite \
	    su-exec \
	    tzdata \
	# Create git user, change root and git passwords
	&& addgroup -S -g 1000 git \
	&& adduser \
		-S \
		-s "/bin/bash" \
		-g "Git Version Control for Gitea" \
		-G git \
		-D \
		-u 1000 \
		-H \
		-h "/data/git" \
		git \
	&& set -euo pipefail ; \
	echo "root:$(head -c 32 /dev/urandom | base64)" | chpasswd ; \
  echo "git:$(head -c 32 /dev/urandom | base64)" | chpasswd

# Setting environment variables for Gitea
ENV USER=git
ENV GITEA_CUSTOM=/data/gitea GITEA_WORK_DIR=/data/gitea
ENV GODEBUG=netdns=go

# Run as user 'git'
USER git

# Expose ports 22 for SSH, and 3000 for web interface
EXPOSE 22 3000

# Set the volume
VOLUME ["/data"]

# System call signal that will be sent to the container to exit
STOPSIGNAL SIGTERM

# Command used to start Gitea
ENTRYPOINT ["gitea", "web"]

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      dockerfile.github.page="https://github.com/HarshaVardhanJ/docker_files/blob/master/gitea/Dockerfile" \
      description="This Dockerfile creates an image containing Gitea, which is a light-weight self-hosted \
      Git repository." \
      version="1.0"
