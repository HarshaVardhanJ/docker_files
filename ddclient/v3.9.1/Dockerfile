############ Dockerfile for 'ddclient' on Alpine Linux  #############
#                                                                   #
#####################################################################
#           CONTAINERISED DDCLIENT BUILT ON ALPINE LINUX            #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Imports a pinned version of Alpine Linux as base image.     #
#    2. Updates the repositories via the package manager.           #
#    3. Installs the dependencies for building ddclient.            #
#    4. Downloads a pinned version of 'ddclient', extracts the      #
#       files, and moves the binary to a directory under PATH.      #
#    5. Removes unnecessary files after installation.               #
#    6. Creates an empty config file to the '/etc/ddclient' folder, #
#       a PID file in /var/run/, and creates the cache folder at    #
#       '/var/cache/ddclient'.                                      #
#    7. Creates an unprivileged user account which will be used     #
#       as the default user within the container, and to run the    #
#       the 'ddclient' executable.                                  #
#    8. Changes permissions and ownership on the config file,       #
#       cache directory, and the pid file.                          #
#    9. Sets the default user as the unprivileged user account      #
#       which was created in the previous step.                     #
#   10. Runs the 'ddclient' binary in verbose mode in the           #
#       foreground.                                                 #
#                                                                   #
# Note : Do not forget to bind mount the config file populated with #
#        values specific to your needs to                           #
#        `/etc/ddclient/ddclient.conf`                              #
#                                                                   #
#####################################################################

# Use pinned version of Alpine Linux as base
FROM alpine:3.11.5

# Setting the working directory to '/'
WORKDIR /

# Setting ARG values for injecting metadata during build time
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=3.9.1

# Install dependencies for `ddclient`
RUN apk update -U --no-cache \
		&& apk add --no-cache --virtual .removable \
      make \
    && apk add --no-cache \
      perl \
      perl-utils \
      perl-test-taint \
      perl-netaddr-ip \
      perl-net-ip \
      perl-yaml \
      perl-log-log4perl \
      perl-io-socket-ssl \
    # Configuring Perl for `ddclient`
    #
    && cpan Data::Validate::IP \
    # Download the latest version of `ddclient`
    #
    && wget -qc https://github.com/ddclient/ddclient/archive/v$VERSION.tar.gz -O ddclient.tar.gz \
    && tar -xvzf ddclient.tar.gz \
    # Move the binary to the appropriate directory
    #
    && mv ddclient*/ddclient /usr/bin \
    # Clean up after installation
    #
    && rm -rf ddclient* \
    && apk del --no-cache --purge .removable \
    && rm -rf /tmp/cpan* \
    && rm -rf /root/.cpan \
    && rm -rf /lib/apk/db \
    && rm -rf /etc/apk/world \
    && rm -rf /usr/local/share/man \
    # Create directories for `ddclient` and creating config file
    #
    && mkdir -p /etc/ddclient /var/cache/ddclient \
    && touch /etc/ddclient/ddclient.conf /var/run/ddclient.pid \
    # Creating ddclient user and group
    #
    && addgroup -S -g 1000 ddclient \
    && adduser -H -g "User account for ddclient" -s /bin/nologin -G ddclient -u 1000 -S -D ddclient \
    # Changing ownership of files that `ddclient` will need to access
    #
    && chown ddclient:ddclient -R /etc/ddclient /var/cache/ddclient /var/run/ddclient.pid \
    && chmod 600 /etc/ddclient/ddclient.conf

# Run as user ddclient
USER ddclient

# System call signal that will be sent to the container to exit
STOPSIGNAL SIGTERM

# The CMD which can be overriden by any command provided during `docker run`
CMD ["/usr/bin/ddclient", "-verbose", "-file", "/etc/ddclient/ddclient.conf", "-foreground", "-pid", "/var/run/ddclient.pid", "&"]

# Labels
LABEL org.opencontainers.image.vendor="Harsha Vardhan J" \
      org.opencontainers.image.authors="https://github.com/HarshaVardhanJ" \
      org.opencontainers.image.title="ddclient" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/docker_files/tree/master/ddclient" \
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/docker_files/tree/master/ddclient" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/ddclient/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/master/ddclient/v3.9.1/Dockerfile" \
      org.opencontainers.image.description="This Dockerfile creates an image containing the utility 'ddclient', which is \
      used for updating Dynamic DNS(DDNS) records." \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.build-date=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF \
      org.label-schema.vcs-ref=$VCS_REF \
      org.opencontainers.image.version=$VERSION \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      software.release.version=$VERSION
