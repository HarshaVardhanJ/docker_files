##########   Dockerfile for Gitea based on Alpine Linux    ##########
#                                                                   #
#####################################################################
#         CONTAINERISED GITEA BUILT ON TOP OF ALPINE LINUX          #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Starts with Golang:alpine as first stage of build.          # 
#    2. Installs dependencies for building Gitea.                   #
#    3. Sets environment variables required by Go.                  # 
#    5. Obtains the source code for Gitea.                          #
#    6. Builds Gitea from the source code to generate a binary.     #
#    7. Uses Alpine Linux as the next(and final) stage of build.    #
#    8. Copies the Gitea binary to a directory under PATH.          #
#    9. Installs dependencies required by Gitea.                    #
#   10. Creates an unprivileged user account which will be used     #
#       as the default user within the container, and to run Gitea. #
#    9. Changes passwords of root user and previously created       #
#       unprivileged user to randomly generated values.             #
#   10. Sets some environment variables required by Gitea.          #
#   11. Sets the default user as the unprivileged user account      #
#       which was created in the previous step.                     #
#   12. Exposes port 22 and 3000 on the container.                  #
#   13. Sets the volume which will be used by Gitea to store data.  #
#   14. Runs the Gitea executable along with its web server.        #
#                                                                   #
# Note : If you wish to have the data persist in Gitea, you will    #
#        need to bind-mount a volume on the host to the container.  #
#        Also, don't forget to expose the required ports on the     #
#        host.                                                      #
#                                                                   #
#####################################################################

# Start with golang image as builder step
FROM golang:alpine as gitea-build

# Setting the version numbers for NodeJS, NPM, and Gitea
ARG NODEJS_VERSION=12.15.0-r1
ARG NPM_VERSION=12.15.0-r1
ARG GITEA_VERSION=1.11.0

# Setting build tags for Gitea
ARG BUILD_TAGS="bindata sqlite sqlite_unlock_notify"

# Environment variable(setting GOPATH)
ENV GOPATH="/go"
ENV PATH="${GOPATH}:${GOPATH}/bin:${PATH}"

# Install dependencies for building Gitea
RUN apk add --no-cache --virtual .go-deps \
      build-base \
      gcc \
      git \
      make \
      musl-dev \
      nodejs=$NODEJS_VERSION \
      npm=$NPM_VERSION \
    # Cloning the Gitea repository
    #
    && git clone https://github.com/go-gitea/gitea \
    && cd gitea \
    # Checking out a tagged version of Gitea
    #
    && git checkout v$GITEA_VERSION \
    # Building Gitea
    #
    && TAGS="${BUILD_TAGS}" make build


#ENV SRC_DIR="${GOPATH}/src/code.gitea.io/gitea"
#
# Getting the source code for Gitea
#RUN go get -d -u code.gitea.io/gitea

# Changing working directory
#WORKDIR "$SRC_DIR"

# Arguments for build options
#ARG BUILD_TAGS="bindata sqlite sqlite_unlock_notify"
#
## Building Gitea
#RUN TAGS="${BUILD_TAGS}" make generate build
#

# Start with Alpine Linux as base image
FROM alpine:3.11.5

# Copy the Gitea binary from the builder step
#COPY --from=gitea-build /go/src/code.gitea.io/gitea/gitea /usr/local/bin/gitea
COPY --from=gitea-build /gitea/gitea /usr/local/bin/gitea

# Install dependencies for Gitea
RUN apk add --no-cache --virtual .gitea-deps \
	    linux-pam \
	    bash \
	    git \
	    sqlite \
	    su-exec \
	    tzdata \
	# Create git user, change root and git user passwords
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

# Setting ARG values for injecting metadata during build time
ARG BUILD_DATE
ARG VCS_REF
ARG GITEA_VERSION=1.11.0

# Run as user 'git'
USER git

# Expose ports 22 for SSH, and 3000 for web interface
EXPOSE 22 3000

# Set the volume
VOLUME ["/data"]

# System call signal that will be sent to the container to exit
STOPSIGNAL SIGTERM

# Command used to start Gitea
ENTRYPOINT ["gitea"]

# Starting the web server
CMD ["web"]

# Labels
LABEL org.opencontainers.image.vendor="Harsha Vardhan J" \
      org.opencontainers.image.title="gitea" \
      org.opencontainers.image.authors="https://github.com/HarshaVardhanJ" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/docker_files/tree/master/gitea" \
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/docker_files/tree/master/gitea" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/gitea/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/master/gitea/Dockerfile" \
      org.opencontainers.image.description="This Dockerfile creates a container image of Gitea, which is a light-weight \
      self-hosted Git repository." \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.build-date=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF \
      org.label-schema.vcs-ref=$VCS_REF \
      org.opencontainers.image.version=$GITEA_VERSION \
      org.label-schema.version=$GITEA_VERSION \
      org.label-schema.schema-version="1.0" \
      software.author.github.page="https://github.com/go-gitea/gitea" \
      software.release.version=$GITEA_VERSION

