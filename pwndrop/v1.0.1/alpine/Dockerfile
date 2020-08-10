################## Dockerfile for 'pwndrop' server ##################
#                                                                   #
#####################################################################
#       CONTAINERISED PWNDROP BUILT ON TOP OF ALPINE LINUX          #
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
#    5. Changes the 'go build' command in the 'build.sh' file and   #
#       Makefile in order to build for different architectures.     #
#    6. Builds the binary from the source code.                     #
#    7. Starts with a pinned-version of Alpine for the final stage. #
#    8. Copies the necessary files from the first stage.            #
#    9. Updates the PATH variable to include the path under which   #
#       'pwndrop' is present.                                       #
#   10. Cleans up by removing installation files and packages.      #
#   11. Sets the ports to be exposed.                               #
#   12. Sets the volume where data for 'pwndrop' will be stored.    #
#   13. Starts the 'pwndrop' executable as the main command.        #
#   14. Sets the arguments to the 'pwndrop' executable.             #
#                                                                   #
# Note : Do not forget to bind-mount a directory to the container   #
#        at the path declared by the VOLUME directive. This is      #
#        where the data will be stored.                             #
#        Also, do not forget to expose ports on the host machine    #
#        on which 'pwndrop' listens(port 53, 80, 443).              #
#                                                                   #
#        One line in the build script is being modified in order    #
#        to build the Go code for different architectures rather    #
#        than the default 'amd64'. Now, making use of the GOOS and  #
#        GOARCH environment variables, the Go binary can be built   #
#        for different platforms without having to hard-code the    #
#        value in the build script.                                 #
#                                                                   #
#        When the image is being built using 'buildx', some         #
#        variables are made available, such as TARGETOS and         #
#        TARGETPLATFORM. These can be set as environment variables  #
#        and be used to build the Go binary for that specific       #
#        platform and architecture.                                 #
#                                                                   #
#####################################################################


# Start with golang:1.14-alpine3.12 as Go version 1.13 
# is the minimum version required by 'pwndrop'
FROM golang:1.14-alpine3.12 AS builder

# ARG value for version-pinning pwndrop release
ARG PWNDROP_VERSION=1.0.1

# Defining ARG values for OS and arch that will be injected during build time
ARG TARGETOS
ARG TARGETARCH

# Setting environment variables that can be used by scripts within the container
ENV TARGETOS=$TARGETOS
ENV TARGETARCH=$TARGETARCH

# Update repo info
#
RUN apk update --no-cache \
    # Install the packages needed to build 'pwndrop'
    #
    && apk add --no-cache \
      gcc \
      libc-dev \
      libc6-compat \
      make \
    # Download the pinned release of 'pwndrop'
    #
    && wget https://github.com/kgretzky/pwndrop/archive/$PWNDROP_VERSION.tar.gz -O pwndrop.tar.gz \
    # Extract the tarball
    #
    && tar -xzf pwndrop.tar.gz \
    && mv pwndrop-* pwndrop \
    && cd pwndrop \
    # Replacing a line in 'build.sh' and Makefile
    #
    && sed -ri "s/GOARCH=amd64(.*)/GOOS=\${TARGETOS:-linux}\ GOARCH=\${TARGETARCH:-amd64}\1/g" ./build.sh ; \
    sed -ri "s/(\t+)@GOARCH=amd64(.*)/\1@GOOS=\${TARGETOS:-linux}\ GOARCH=\${TARGETARCH:-amd64}\2/g" ./Makefile ; \
    # Build the binary
    #
    make


# Using Alpine for final stage
FROM alpine:3.12.0

# Copy required files from build stage
COPY --from=builder /go/pwndrop/build /pwndrop

# ARG values for injecting metadata during build time
# NOTE: When using ARGS in a multi-stage build, remember to redeclare
#       them for the stage that needs to use it. ARGs last only for the
#       lifetime of the stage that they're declared in.
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=1.0.1

# Setting PATH variable to include the installation path of 'pwndrop'
ENV PATH="/pwndrop:${PATH}"

# Set the working directory
WORKDIR /pwndrop

# Cleanup
RUN rm -rf /lib/apk/db/scripts.tar

# Expose DNS, HTTP, HTTPS ports
EXPOSE 53 80 443

# Setting the volume where data is stored
VOLUME ["/pwndrop/data"]

# Entrypoint command which will be executed when container runs
ENTRYPOINT ["pwndrop"]

# Arguments to the entrypoint command
CMD ["-config", "/pwndrop/pwndrop.ini", "-debug", "-no-autocert"]

# Labels
LABEL org.opencontainers.image.vendor="Harsha Vardhan J" \
      org.opencontainers.image.authors="https://github.com/HarshaVardhanJ" \
      org.opencontainers.image.title="pwndrop" \
      org.opencontainers.image.licenses="GPLv3 AND MIT" \
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/docker_files/tree/master/pwndrop" \
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/docker_files/tree/master/pwndrop" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/v1.0.1/alpine/Dockerfile" \
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
