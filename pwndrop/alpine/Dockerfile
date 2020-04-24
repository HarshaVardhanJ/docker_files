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
#    3. Installs packages necessary for building 'pwndrop', and for #
#       granting the 'pwndrop' executable access to privileged      #
#       ports(<1024).                                               #
#    4. Downloads a pinned-version of the release of 'pwndrop' and  #
#       extracts the tar ball.                                      #
#    5. Changes the 'go build' command in the 'Makefile' file in    #
#       order to build for different architectures.                 #
#    6. Builds the binary from the source code.                     #
#    7. Grant access to privileged ports to 'pwndrop' executable.   #
#    8. Add non-root user and group which will be used to run as    #
#       primary user in container and to run 'pwndrop'.             #
#    9. Create 'data' directory for 'pwndrop'.                      #
#   10. Starts with a pinned-version of Alpine for the final stage. #
#   11. Copies the necessary files from the first stage.            #
#   12. Updates the PATH variable to include the path under which   #
#       'pwndrop' will be installed.                                #
#   13. Updates package repository information and installs package #
#       necessary for granting access to privileged ports.          #
#   14. Changes passwords of root user and previously created       #
#       unprivileged user account.                                  #
#   15. Cleans up by removing installation files and packages.      #
#   16. Sets the ports to be exposed.                               #
#   17. Sets the volume where data for 'pwndrop' will be stored.    #
#   18. Starts the 'pwndrop' executable as the main command.        #
#   19. Sets the arguments to the 'pwndrop' executable.             #
#                                                                   #
# Note : Do not forget to bind-mount a directory to the container   #
#        at the path declared by the VOLUME directive. This is      #
#        where the data will be stored.                             #
#        Also, do not forget to expose ports on the host machine    #
#        on which 'pwndrop' listens(port 53, 80, 443).              #
#                                                                   #
#####################################################################


# Start with golang:1.13-alpine as Go version 1.13
# is the minimum version required by 'pwndrop'
FROM golang:1.13-alpine AS builder

# ARG value for link to repository which will be cloned
ARG PWNDROP_VERSION=1.0.0

# ARG values that can be used to inject OS and arch information during build time
ARG TARGETOS
ARG TARGETARCH

# Setting environment variables that can be used by scripts running in the container
ENV TARGETOS=$TARGETOS
ENV TARGETARCH=$TARGETARCH

# Update repo info
#
RUN apk update --no-cache \
    # Install the packages needed to build 'pwndrop', and to grant the pwndrop executable
    # the permission to bind to privileged ports(<1024)
    #
    && apk add --no-cache \
      gcc \
      make \
      libcap \
    # Download the pinned release of 'pwndrop'
    #
    && wget https://github.com/kgretzky/pwndrop/archive/$PWNDROP_VERSION.tar.gz -O pwndrop.tar.gz \
    # Extract the tarball
    #
    && tar -xzf pwndrop.tar.gz \
    && mv pwndrop-* pwndrop \
    && cd pwndrop \
    # Replacing a line in Makefile
    #
    && sed -ri "s/(\t+)@GOARCH=amd64(.*)/\1@GOOS=\${TARGETOS:-linux}\ GOARCH=\${TARGETARCH:-amd64}\2/g" ./Makefile \
    # Build the binary
    #
    && make \
    # Giving the 'pwndrop' process access to privileged ports
    #
    && setcap 'cap_net_bind_service=+ep' ./build/pwndrop \
    # Create non-root user and group
    #
    && addgroup -S -g 1000 pwndrop \
    && adduser -H -h /pwndrop -g "User account for pwndrop" -s /bin/nologin -G pwndrop -u 1000 -S -D pwndrop \
    && mkdir ./build/data


# Using Alpine for final stage
FROM alpine:3.11.6

# Copy required files from build stage
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --chown=pwndrop:pwndrop --from=builder /go/pwndrop/build /pwndrop/

# ARG values for injecting metadata during build time
# NOTE: When using ARGS in a multi-stage build, remember to redeclare
#       them for the stage that needs to use it. ARGs last only for the
#       lifetime of the stage that they're declared in.
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=1.0.0

# Setting PATH variable to include the installation path of 'pwndrop'
ENV PATH="/pwndrop:${PATH}"

# Set the working directory
WORKDIR /pwndrop

# Changing the passwords of root and non-root user
RUN set -euo pipefail ; \
    echo "root:$(head -c 32 /dev/urandom | base64)" | chpasswd ; \
    echo "pwndrop:$(head -c 32 /dev/urandom | base64)" | chpasswd ; \
    # Installing 'libcap' package
    #
    apk update --no-cache \
    && apk add --no-cache libcap \
    # Clean up
    && rm -f /lib/apk/db/scripts.tar /lib/apk/db/triggers

# Run as user 'pwndrop' inside container
USER pwndrop

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
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/docker_files/tree/non-root/pwndrop" \
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/docker_files/tree/non-root/pwndrop" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/pwndrop/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/non-root/pwndrop/alpine/Dockerfile" \
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
