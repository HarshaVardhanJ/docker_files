##################  Dockerfile for UPX on Busybox  ##################
#                                                                   #
#####################################################################
#          CONTAINERISED UPX BUILT ON TOP OF BUSYBOX IMAGE          #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Starts with a base image of Debian Buster Slim.             #
#    2. Sets the '-static' build flag as an environment variable    #
#       which is used to build a statically-linked binary.          #
#    3. Downloads git and obtains a version-pinned release of UPX.  #
#    4. Installs packages necessary for source code compilation.    # 
#    5. Compiles the source code to generate the executable.        #
#    6. Compresses the executable using UPX and saves it to a       #
#       specific location in order to reduce the size of the final  #
#       image.                                                      #
#    7. Starts with Busybox as base in the final build stage.       #
#    8. Sets some ARG values used for injecting metadata during     #
#       build process of image.                                     #
#    9. Copies the 'upx' executable from the previous build stage.  #
#   10. Runs the 'upx' executable with flags set for best           #
#       compression of executable.                                  #
#                                                                   #
# Note : In order to use this image, pass the name and location to  #
#        which you wish to save the compressed binary, followed by  #
#        the location of the binary which is to be compressed.      #
#                                                                   #
#        Example:                                                   #
#                 upx-container /save/to/file /path/to/binary       #
#                                                                   #
#        This will compress and save 'binary' at '/save/to/file'    #
#                                                                   #
#####################################################################

# Start with Debian Buster Slim as base for first stage
FROM debian:buster-slim as intermediate

# ARG values for injecting metadata during build time
# NOTE: When using ARGS in a multi-stage build, remember to redeclare
#       them for the stage that needs to use it. ARGs last only for the
#       lifetime of the stage that they're declared in.
ARG BUILD_DATE
ARG VCS_REF
# Commit hash corresponding to version 3.95
ARG VERSION_COMMIT_HASH=7a3637ff5a800b8bcbad20ae7f668d8c8449b014

# Set build flags as environment variable to compile the binary as statically linked
ENV LDFLAGS="-static"

# Update repo cache and download git
#
RUN apt update && apt install -y git \
    # Fetch the source code pertaining to the pinned version
    #
    && git clone --recursive https://github.com/upx/upx.git /upx \
    && git -C /upx reset --hard $VERSION_COMMIT_HASH \
    # Install packages needed to compile the source code
    #
    && apt install -y \
        g++ \
        gcc \
#        libgcc-s1-arm64-cross \
#        libgcc-s1-armel-cross \
#        libgcc-s1-armhf-cross \
#        libgcc-s1-i386-cross \
#        libgcc-s1-ppc64el-cross \
#        libgcc-s1-s390x-cross \
        linux-libc-dev \
        libc6 \
        libc6-dev \
        zlib1g-dev \
        libucl-dev \
        make \
    # Build the executable
    #
    && make -j10 -C /upx/src upx.out CHECK_WHITESPACE= \
    # Compress the executable and save it to the specified location
    #
    && /upx/src/upx.out --lzma --best -o /upx/upx /upx/src/upx.out

# Start with busybox for final base image
FROM busybox

# ARG values for injecting metadata during image build
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=3.95

# Copy the 'upx' binary from the first stage of the build
COPY --from=intermediate /upx/upx /usr/bin/upx

# System call signal that will be sent to the container to exit
STOPSIGNAL SIGTERM

# Set the entrypoint command to 'upx'
ENTRYPOINT ["/usr/bin/upx", "--lzma", "--best", "-o"]

# Empty command value
CMD []

# Labels
LABEL org.opencontainers.image.vendor="Harsha Vardhan J" \
      org.opencontainers.image.authors="https://github.com/HarshaVardhanJ" \
      org.opencontainers.image.title="upx" \
      org.opencontainers.image.licenses="GPL AND MIT" \
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/docker_files/tree/master/upx" \
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/docker_files/tree/master/upx" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/upx/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/master/upx/v3.95/busybox/Dockerfile" \
      org.opencontainers.image.description="This Dockerfile creates an image containing the binary 'upx' which is an \
      advanced executable file compressor." \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.build-date=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF \
      org.label-schema.vcs-ref=$VCS_REF \
      org.opencontainers.image.version=$VERSION \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      software.author.github.page="https://github.com/upx/upx" \
      software.release.version=$VERSION
