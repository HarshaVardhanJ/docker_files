# Dockerfile for customising binfmt image
## Influenced by https://github.com/linuxkit/linuxkit/tree/master/pkg/binfmt
### Adds support for more architectures in docker buildx

FROM debian:stretch-slim AS qemu-risc-builder

    # Update package index
RUN apt-get update \
    # Install tools necessary for building qemu
    && apt install --no-install-recommends -y \
      build-essential \
      ca-certificates \
      file \
      git \
      libglib2.0-dev \
      libpixman-1-dev \
      python \
      pkgconf \
    # Clone the 'qemu' git repository
    && git clone https://git.qemu.org/git/qemu.git \
    # Build QEMU with support for riscv64 emulation
    && cd qemu \
    && ./configure --static --disable-system --target-list=riscv64-linux-user \
    && make \
    && cp riscv64-linux-user/qemu-riscv64 /qemu-riscv64

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
    && mv qemu-s390x-static qemu-s390x


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
COPY --from=qemu-risc-builder /qemu-riscv64 usr/bin/

# Copy the binfmt binary
COPY --from=binfmt-builder /go/bin/binfmt usr/bin/binfmt

# Copy the binfmt config file
COPY etc/binfmt.d/00_linuxkit.conf etc/binfmt.d/00_linuxkit.conf

# Running the binfmt command
CMD ["/usr/bin/binfmt"]
