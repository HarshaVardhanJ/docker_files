######### Dockerfile for ddclient service on Alpine Linux.  #########
#                                                                   #
#####################################################################
#     DOCKERISED DDCLIENT SERVICE BUILT ON TOP OF ALPINE LINUX      #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Imports the latest base image of Alpine Linux.              #
#    2. Updates the repositories via the package manager.           #
#    3. Installs the dependencies for building ddclient.            #
#    5. Downloads the latest version of `ddclient`.                 #
#    6. Creates an empty config file to the `/etc/ddclient` folder, #
#       and creates the cache folder at `/var/cache/ddclient`.      #
#    8. Changes permissions on the config file, cache directory,    #
#       and the pid file.                                           #
#    9. Runs the `ddclient` binary.                                 #
#                                                                   #
# Note : Do not forget to bind mount the config file populated with #
#        values specific to your needs to                           #
#        `/etc/ddclient/ddclient.conf`                              #
#                                                                   #
#####################################################################

# Use latest image of Alpine Linux as base
FROM alpine:latest

# Setting the working directory to '/'
WORKDIR /

# Setting the version for `ddclient`
ARG ddclientVersion=v3.9.0

# Install dependencies for `ddclient`
RUN apk update \
		&& apk add --no-cache --virtual .removable \
      make \
    && apk add --no-cache --virtual .ddclient-deps \
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
    && cpan install Test::Requires \
    && cpan Data::Validate::IP \
    # Download the latest version of `ddclient`
    #
    && wget -qc https://github.com/ddclient/ddclient/archive/$ddclientVersion.tar.gz -O ddclient.tar.gz \
    && tar -xvzf ddclient.tar.gz \
    # Move the binary to the appropriate directory
    #
    && mv ddclient*/ddclient /usr/bin \
    # Clean up after installation
    #
    && rm -rf ddclient* \
    && apk del --no-cache --purge .removable \
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

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      dockerfile.github.page="https://github.com/HarshaVardhanJ/docker_files/blob/master/ddclient/Dockerfile"
      description="This Dockerfile creates an image containing \
      the utility `ddclient`, which is used for updating Dynamic DNS \
      records." \
      version="1.0"
