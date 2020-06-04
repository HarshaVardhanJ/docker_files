################## Dockerfile for 'pwndrop' server ##################
#                                                                   #
#####################################################################
#          CONTAINERISED PWNDROP BUILT ON TOP OF BUSYBOX            #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Starts with a pinned-version of Golang Alpine for the       # 
#       first stage of the build.                                   #
#    2. Updates package repository information.                     #
#    3. Installs packages necessary for building 'pwndrop'.         # 
#    4. Downloads a pinned-version of the release of 'pwndrop' and  #
#       extracts the tar ball.                                      #
#    5. Changes the 'go build' command in the Makefile in order to  #
#       build for different architectures and statically-linked.    #
#    6. Builds the binary from the source code.                     #
#    7. Add non-root user and group which will be used to run as    #
#       primary user in container and to run 'pwndrop'.             #
#    8. Create 'data' directory for 'pwndrop'.                      #
#    9. Starts with a Busybox for the final stage.                  #
#   10. Copies the necessary files from the first stage, including  #
#       the default 'pwndrop.ini' config file from the host.        #
#   11. Updates the PATH variable to include the path under which   #
#       'pwndrop' is present.                                       # 
#   12. Changes passwords of root user and previously created       #
#       unprivileged user account.                                  #
#   13. Sets the 'run as' user to the non-root user.                #
#   14. Sets the ports to be exposed.                               #
#   15. Sets the volume where data for 'pwndrop' will be stored.    #
#   16. Starts the 'pwndrop' executable as the main command.        #
#   17. Sets the arguments to the 'pwndrop' executable.             #
#                                                                   #
# Note : Do not forget to bind-mount a directory to the container   #
#        at the path declared by the VOLUME directive. This is      #
#        where the data will be stored.                             #
#        Also, do not forget to expose ports on the host machine    #
#        on which 'pwndrop' listens(8080, 8443).                    #
#        The DNS server cannot be started in this image as the      #
#        'pwndrop' user does not have permission to bind to         #
#        privileged ports(<1024). Therefore, the HTTP and HTTPS     #
#        ports have been set to 8080 and 8443 respectively. Since   #
#        the DNS server's port cannot be changed, the executable is #
#        started with the '-no-dns' option.                         #
#                                                                   #
#        One line in the Makefile is being modified in order to     #
#        build the Go code for different architectures and as       #
#        statically-linked. Now, making use of the GOOS and GOARCH  #
#        environment variables, the Go binary can be built for      #
#        different platforms without having to hard-code the value  #
#        in the build script.                                       #
#                                                                   #
#        When the image is being built using 'buildx', some         #
#        variables are made available, such as TARGETOS and         #
#        TARGETPLATFORM. These can be set as environment variables  #
#        and be used to build the Go binary for that specific       #
#        platform and architecture.                                 #
#                                                                   #
#####################################################################


# Start with golang:1.13-alpine as Go version 1.13 
# is the minimum version required by 'pwndrop'
FROM golang:1.13-alpine AS builder

# ARG value for link to repository which will be cloned
ARG PWNDROP_VERSION=1.0.0

# ARG values about OS and arch that will be available to buildx during build time
ARG TARGETOS
ARG TARGETARCH

# Exporting the OS and arch values as environment variables to be used by scripts
# within the container
ENV TARGETOS=$TARGETOS
ENV TARGETARCH=$TARGETARCH

# Update repo info
#
RUN apk update --no-cache \
    # Install the packages needed to build 'pwndrop'
    #
    && apk add --no-cache \
      gcc \
      make \
    # Download the pinned release of 'pwndrop'
    #
    && wget https://github.com/kgretzky/pwndrop/archive/$PWNDROP_VERSION.tar.gz -O pwndrop.tar.gz \
    # Extract the tarball
    #
    && tar -xzf pwndrop.tar.gz \
    && mv pwndrop-* pwndrop \
    && cd pwndrop \
    # Replacing a line in the Makefile
    #
    && sed -ri "s/(\t+)@GOARCH=amd64(.*)/\1@CGO_ENABLED=0\ GOOS=\${TARGETOS:-linux}\ GOARCH=\${TARGETARCH:-amd64}\ go\ build\ -a\ -tags\ netgo\ -ldflags\ '-s\ -w\ -extldflags\ \"-static\"'\ -o\ \$\(BUILD_DIR\)\\/\$\(TARGET\)\ -mod=vendor\ main\.go/g" ./Makefile ; \
    # Build the binary
    #
    make \
    # Create non-root user and group
    #
    && addgroup -S -g 1000 pwndrop \
    # Create 'data' directory for use by 'pwndrop'
    #
    && adduser -H -h /pwndrop -g "User account for pwndrop" -s /bin/nologin -G pwndrop -u 1000 -S -D pwndrop \
    && mkdir ./build/data



# Using busybox for final stage
FROM busybox

# Copy required files from builder stage
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --chown=pwndrop:pwndrop --from=builder /go/pwndrop/build /pwndrop/

# Copy default config file from the host
COPY ./pwndrop.ini /pwndrop/pwndrop.ini

# Setting PATH variable to include the installation path of 'pwndrop'
ENV PATH="/pwndrop:${PATH}" 

# ARG values for injecting metadata during build time
# NOTE: When using ARGS in a multi-stage build, remember to redeclare
#       them for the stage that needs to use it. ARGs last only for the
#       lifetime of the stage that they're declared in.
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=1.0.0

# Setting working directory
WORKDIR /pwndrop

# Change passwords of root and non-root user
#
RUN set -euo pipefail ; \
    echo "root:$(head -c 32 /dev/urandom | base64)" | chpasswd ; \
    echo "pwndrop:$(head -c 32 /dev/urandom | base64)" | chpasswd

# Run as user 'pwndrop' inside container
USER pwndrop:pwndrop

# Expose HTTP and HTTPS ports
EXPOSE 8080 8443

# Setting the volume where data is stored
VOLUME ["/pwndrop/data"]

# Entrypoint command which will be executed when container runs
ENTRYPOINT ["pwndrop"]

# Arguments to the entrypoint command
# NOTE: For the 'nonroot-busybox' image, the '-no-dns' option is mandatory.
#       The executable, by default, will try to start a DNS server on port 53,
#       which it cannot do as a non-root user, unless 'libcap' package is
#       installed(which cannot happen on Busybox). Therefore, the '-no-dns'
#       option is necessary for 'pwndrop' to run.
#
CMD ["-debug", "-no-autocert", "-config", "/pwndrop/pwndrop.ini", "-no-dns"]

# Labels
LABEL org.opencontainers.image.vendor="Harsha Vardhan J" \
      org.opencontainers.image.authors="https://github.com/HarshaVardhanJ" \
      org.opencontainers.image.title="pwndrop" \
      org.opencontainers.image.licenses="GPLv3 AND MIT" \
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/docker_files/tree/non-root/pwndrop" \
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/docker_files/tree/non-root/pwndrop" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/non-root/pwndrop/busybox/Dockerfile" \
      org.opencontainers.image.description="Self-deployable file hosting service for red teamers, allowing to easily upload \
      and share payloads over HTTP and WebDAV." \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.build-date=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF \
      org.label-schema.vcs-ref=$VCS_REF \
      org.opencontainers.image.version=$VERSION \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      software.author.repository="https://github.com/kgretzky/pwndrop" \
      software.release.version=$VERSION
