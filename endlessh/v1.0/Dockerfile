##############  Dockerfile for 'endlessh' on Scratch  ###############
#                                                                   #
#####################################################################
#        CONTAINERISED ENDLESSH BUILT ON TOP OF SCRATCH IMAGE       #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Starts with a base image of Alpine.                         #
#    2. Downloads a version-pinned release of endlessh, and         #
#       and extracts the contents.                                  #
#    3. Adds '-static' option to the Makefile in order to           #
#       compile the source code as statically executable.           #
#    4. Downloads packages necessary for source code compilation.   #
#    5. Compiles the source code to generate the executable.        #
#    6. Uses UPX as the second stage in order to compress the       #
#       binary built in the previous stage.                         #
#    7. Copies the binary from the first stage.                     #
#    8. Compresses the binary using UPX.                            #
#    9. Starts with Scratch as base in the final build stage.       #
#   10. Sets some ARG values used for injecting metadata during     #
#       build process of image.                                     #
#   11. Copies the 'endlessh' executable from the previous build    #
#       stage.                                                      #
#   12. Exposes port 2222 on the container as this is the port      #
#       'endlessh' will listen on by default.                       #
#   13. Runs the 'endlessh' executable in verbose mode.             #
#                                                                   #
#   NOTE: In step 3, the Makefile is modified in order to compile   #
#         the source code to a statically-linked executable as      #
#         this is the only way it can run on the Scratch image.     #
#         The source code is not edited/tampered with in any way    #
#         or form.                                                  #
#                                                                   #
#####################################################################

# Start with Alpine Linux as builder image
FROM alpine:3.12 as builder

# Setting version number for `endlessh` download
ARG VERSION=1.0

# Download the source code and extract it
RUN wget -qc https://github.com/skeeto/endlessh/archive/$VERSION.tar.gz -O endlessh.tar.gz \
    && tar -xzf endlessh.tar.gz \
    && cd endlessh* \
    # Add the '-static' option to the 'CFLAGS' line 
    # (Used to compile as a statically-linked executable)
    #
    && sed -i 's/-std=c99/-static\ -std=c99/g' ./Makefile \
    # Install the packages needed to compile C code
    #
    && apk update --no-cache && apk add --no-cache \
        gcc \
        libc-dev \
        libc6-compat \
        libgcc \
        libstdc++ \
        make \
      # Compile the code
      #
      && make \
      # Move the executable to the root directory
      #
      && mv endlessh ../ \
      # Creating new user and group for running endlessh
      && addgroup -S -g 1000 endlessh \
      && adduser -H -g "User account for running the endlessh executable" -s /bin/nologin -G endlessh -u 1000 -S -D endlessh


# Use UPX to compress the binary
FROM harshavardhanj/upx:3.95 as compressor

# Copy the binary from the first stage
COPY --from=builder /endlessh /endlessh.orig

# Compress the binary
RUN /usr/bin/upx --lzma --best -o /endlessh /endlessh.orig


# Start from scratch
FROM scratch

# ARG values for injecting metadata during image build
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=1.0

# Copy passwd and groups file from first stage
COPY --from=builder --chown=root:root /etc/passwd /etc/group /etc/

# Copy the executable from the intermediate builder stage
COPY --from=compressor --chown=endlessh:endlessh /endlessh /

# Run as user endlessh
USER endlessh

# Expose port 2222 on which the executable listens
EXPOSE 2222/tcp

# System call signal that will be sent to the container to exit
STOPSIGNAL SIGTERM

# Run the endlessh executable
ENTRYPOINT ["/endlessh"]

# Run it in verbose mode
CMD ["-v"]

# Labels
LABEL org.opencontainers.image.vendor="Harsha Vardhan J" \
      org.opencontainers.image.title="endlessh" \
      org.opencontainers.image.authors="https://github.com/HarshaVardhanJ" \
      org.opencontainers.image.licenses="Unlicense AND MIT" \
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/docker_files/tree/master/endlessh" \
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/docker_files/tree/master/endlessh" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/endlessh/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/master/endlessh/v1.0/Dockerfile" \
      org.opencontainers.image.description="This Dockerfile creates an image containing the executable `endlessh` which is an SSH tarpit \
      that very slowly sends an endless, random SSH banner. It keeps SSH clients locked up for hours or even days \
      at a time. The purpose is to put your real SSH server on another port and then let the script kiddies get \
      stuck in this tarpit instead of bothering a real server." \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.build-date=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF \
      org.label-schema.vcs-ref=$VCS_REF \
      org.opencontainers.image.version=$VERSION \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      software.author.github.page="https://github.com/skeeto/endlessh" \
      software.release.version=$VERSION
