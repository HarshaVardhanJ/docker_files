########## Dockerfile for 'docker buildx' on Alpine Linux. ##########
#                                                                   #
#####################################################################
#      DOCKERISED DOCKER SERVICE WITH BUILDX SUPPORT BUILT ON       #
#                       TOP OF ALPINE LINUX                         #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Imports a pinned version of Alpine Linux.                   #
#    2. Adds the Community repository which contains Docker.        #
#    3. Downloads a specific version of Docker and sets a flag to   #
#       enable experimental features(buildx) in Docker.             #
#    4. Downloads a specific version of the 'buildx' binary from    #
#       GitHub, extracts it, moves it to a directory in $PATH,      #
#       and sets the execute bit on it.                             #
#    5. Sets the 'run as' user as root.                             #
#    6. Copies the 'entrypoint.sh' script to a directory in $PATH.  #
#    7. Runs the 'entrypoint.sh' script, which takes care of        #
#       setting up 'buildx'.                                        #
#                                                                   #
# Note : This file is meant to be on GCP Cloud Build to build       #
#        images with multiple-architecture support. If you wish to  #                        
#        run the image locally, you will need to bind mount the     #
#        socket on which the Docker daemon listens to the           #
#        container.                                                 #
#                                                                   #
#####################################################################

# Starting with the base image of Alpine Linux version 3.11.3
FROM alpine:3.12.0

# Version number of `docker buildx`
ARG buildxVersion=0.3.1

# Version number of the Docker Engine
ARG dockerVersion=19.03.12-r0

# Setting working directory to '/'
WORKDIR /

# System call signal which will be sent to the container to exit
STOPSIGNAL SIGTERM

# Run as user 'root'
USER root

# Run the following commands
    # Adding the 'Community' repository which contains the 'Docker' package
RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories \
    # Updating package index
    && apk update -U --no-cache \
    # Installing Docker of version $dockerVersion
    && apk add --no-cache docker=$dockerVersion \
    # Setting environment variable for enabling experimental features in Docker
    && export DOCKER_CLI_EXPERIMENTAL=1 \
    # Downloading `buildx` binary release
    && wget https://github.com/docker/buildx/releases/download/v${buildxVersion}/buildx-v${buildxVersion}.linux-amd64 \
      -O /usr/bin/buildx \
    # Setting execute permission on the `buildx` executable
    && chmod a+x /usr/bin/buildx \
    # Cleaning up
    && rm -r /lib/apk/db \
    && rm -r /var/cache/apk


# Copying the 'entrypoint' script, which will help configure 'docker-buildx', to a directory
# which is under $PATH
COPY ./entrypoint.sh /usr/bin/

# Run the 'entrypoint.sh' script
ENTRYPOINT ["entrypoint.sh"]

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      dockerfile.github.page="https://github.com/HarshaVardhanJ/docker_files\
/blob/master/docker-cloud-builder/Dockerfile" \
      description="This Dockerfile creates an image of Docker with support for \
`buildx` added. This way, images can be built for multiple architectures. The \
suggested way to use this image is with GCP Cloud Build via a `cloudbuild.yaml` \
file in which this image will need to be invoked as a Cloud Builder. The \
arguments to the Cloud Builder will the same as the argument to the `docker buildx` \
executable. Start the arguments with 'build -f [DOCKERFILE] [BUILD-CONTEXT]. \
Check the sample `cloudbuild.yaml` file in this directory for an example of \
how this image is to be used in a `cloudbuild.yaml` file." \
      version="2.0"
