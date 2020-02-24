# Dockerfile for customising binfmt image
# Adds support for more architectures in docker buildx

# Start with debian stretch slim image
FROM debian:stretch-slim AS qemu

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
    && mv qemu-sparc-static qemu-sparc \
    && mv qemu-sparc32plus-static qemu-sparc32plus \
    && mv qemu-sparc64-static qemu-sparc64
    #&& for fileName in qemu-* ; do mv "${fileName}" "${fileName//-static/}" ; done \


# Start with latest alpine image
FROM alpine:latest AS mirror

# Update repo information
RUN apk update \
    # Upgrade all packages
    && apk upgrade -U \
    && apk add --no-cache \
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
COPY --from=qemu usr/bin/qemu-* usr/bin/

# Copy the binfmt binary
COPY --from=mirror /go/bin/binfmt usr/bin/binfmt

# Copy the binfmt config file
COPY etc/binfmt.d/00_linuxkit.conf etc/binfmt.d/00_linuxkit.conf

# Running the binfmt command
CMD ["/usr/bin/binfmt"]