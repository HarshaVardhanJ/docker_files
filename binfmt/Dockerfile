# Dockerfile for customising binfmt image
## Influenced by https://github.com/linuxkit/linuxkit/tree/master/pkg/binfmt
### Adds support for more architectures in docker buildx

# Start with debian stretch slim image
# Use Debian stretch until https://bugs.alpinelinux.org/issues/8131 is resolved.
FROM debian@sha256:de3eac83cd481c04c5d6c7344cd7327625a1d8b2540e82a8231b5675cef0ae5f AS qemu-builder

# Setting the working directory
WORKDIR /

# Install 'qemu-user-static' package
RUN apt-get update \
    && apt-get install qemu-user-static -y \
    # Rename qemu binaries
    && cd /usr/bin \
    && mv qemu-aarch64-static qemu-aarch64 \
    && mv qemu-arm-static qemu-arm \
    && mv qemu-armeb-static qemu-armeb \
    && mv qemu-i386-static qemu-i386 \
    && mv qemu-ppc64le-static qemu-ppc64le \
    && mv qemu-s390x-static qemu-s390x \
    # Removing other unused qemu binaries
    && rm -f qemu-*static


# Start with latest alpine image
FROM alpine:latest AS binfmt-builder

# Update repo information
RUN apk update \
    # Upgrade all packages
    && apk upgrade -U \
    && apk add --no-cache \
      build-base \
      gcc \
      go \
      musl-dev

# Setting GOPATH and PATH
ENV GOPATH=/go PATH=$PATH:/go/bin

# Copy file to src directory in GOPATH
COPY main.go /go/src/binfmt/

# Copy script to help compile Go code
COPY go-compile.sh /

# Running the compilation script
RUN ./go-compile.sh /go/src/binfmt


# Start with scratch image
FROM scratch

ENTRYPOINT []

# Setting working directory
WORKDIR /

# Copy the qemu binaries
COPY --from=qemu-builder usr/bin/qemu-* usr/bin/

# Copy the binfmt binary
COPY --from=binfmt-builder /go/bin/binfmt usr/bin/binfmt

# Copy the binfmt config file
COPY etc/binfmt.d/00_linuxkit.conf etc/binfmt.d/00_linuxkit.conf

# Running the binfmt command
CMD ["/usr/bin/binfmt"]

# Labels
LABEL org.opencontainers.image.vendor="Harsha Vardhan J" \
      org.opencontainers.image.title="binfmt" \
      org.opencontainers.image.authors="https://github.com/HarshaVardhanJ" \
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/docker_files/tree/master/binfmt" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/binfmt/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/master/binfmt/Dockerfile" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.description="This Dockerfile creates an image which helps enable `binfmt` support thereby \
      helping build multi-architecture container images by leveraging the `buildx` utility in Docker." \
      org.opencontainers.image.version="1.0"
