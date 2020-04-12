###############  Dockerfile for `binfmt` on Scratch  ################
#                                                                   #
#####################################################################
#         CONTAINERISED BINFMT BUILT ON TOP OF SCRATCH IMAGE        #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Starts with a base image of debian stretch slim.            #
#    2. Updates the repositories via the package manager.           #
#    3. Installs the qemu-user-static package.                      #
#    4. Moves(and renames) some of the qemu binaries.               #
#    5. In the next stage, starts with Alpine Linux.                #
#    6. Installs packages needed to compile Go code.                #
#    7. Copies Go file and compilation script.                      #
#    8. Runs the compilation script against the Go code.            #
#    9. In the final stage, starting with Scratch as base.          #
#   10. Copies the qemu binaries from the first stage, and the      #
#       binfmt binary generated in the second stage.                #
#   11. Copies the 'linuxkit.conf' configuration file.              #
#   12. Runs the binfmt binary.                                     #
#                                                                   #
#   NOTE: The final image contains ONLY the 'qemu-user-static'      #
#         binaries, the 'binfmt' binary, and the 'linuxkit.conf'    #
#         configuration file. There are no other files and/or       #
#         binaries present in the image.                            #
#                                                                   #
#####################################################################

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

# ARG values for injecting image metadata during build time
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=1.0

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
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/docker_files/tree/master/binfmt" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/binfmt/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/master/binfmt/Dockerfile" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.description="This Dockerfile creates an image which helps enable `binfmt` support thereby \
      helping build multi-architecture container images by leveraging the `buildx` utility in Docker." \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.build-date=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF \
      org.label-schema.vcs-ref=$VCS_REF \
      org.opencontainers.image.version=$VERSION \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
