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
#    1. Imports the latest base image of Alpine Linux.              #
#    2. Adds the Community repository which contains Docker.        #
#    3. Upgrades all existing packages to their latest version.     #
#    5. Downloads a specific version of Docker and sets a flag to   #
#       enable experimental features(buildx) in Docker.             #
#    6. Downloads a specific version of the 'buildx' binary from    #
#       GitHub, extracts it, moves it to a directory in $PATH,      #
#       and sets the execute bit on it.                             #
#    7. Creates a user 'docker' who is part of the 'docker' group.  #
#    8. Sets the 'run as' user as 'docker'.                         #
#    9. Copies the 'entrypoint.sh' script to a directory in $PATH.  #
#   10. Runs the 'entrypoint.sh' script, which takes care of        #
#       setting up 'buildx'.                                        #
#                                                                   #
# Note : This file is meant to be on GCP Cloud Build to build       #
#        images with multiple-architecture support. If you wish to  #                        
#        run the image locally, you will need to bind mount the     #
#        socket on which the Docker daemon listens to the           #
#        container.                                                 #
#                                                                   #
#####################################################################

# Starting with the base image of the latest version of Alpine Linux
FROM alpine:latest

# Version number of `docker buildx`
ARG buildxVersion=0.3.1

# Version number of the Docker Engine
ARG dockerVersion=19.03.5-r0

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
    # Installing Docker of version $dockerVersion and 'su-exec'
    && apk add --no-cache \
      docker=$dockerVersion \
      su-exec \
    # Setting environment variable for enabling experimental features in Docker
    && export DOCKER_CLI_EXPERIMENTAL=1 \
    # Downloading `buildx` binary release
    && wget https://github.com/docker/buildx/releases/download/v${buildxVersion}/buildx-v${buildxVersion}.linux-amd64 \
    # Moving `buildx` binary to a directory which is under $PATH
    && mv buildx-v${buildxVersion}.linux-amd64 /usr/bin/docker-buildx \
    # Setting execute permission on the `buildx` executable
    && chmod a+x /usr/bin/docker-buildx \
    # Creating user 'docker'
    && adduser --gecos "Docker user" --shell /bin/nologin --ingroup docker --home /home/docker --system --uid 1000 docker \
    # Creating socket file for communicating with Docker daemon
    && touch /var/run/docker.sock \
    # Changing ownership of socket file
    && chown -v docker:docker /var/run/docker.sock

# Run as user 'root'
#USER docker

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
arguments to the Cloud Builder will the same as the argument to the `buildx` \
executable. Start the arguments with 'build -f [DOCKERFILE] [BUILD-CONTEXT]. \
Check the sample `cloudbuild.yaml` file in this directory for an example of \
how this image is to be used in a `cloudbuild.yaml` file." \
      version="1.0"
