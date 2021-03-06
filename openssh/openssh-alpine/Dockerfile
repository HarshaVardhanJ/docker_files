########### Dockerfile for OpenSSH server on Alpine Linux ###########
#                                                                   #
#####################################################################
#    CONTAINERISED OPENSSH SERVER BUILT ON TOP OF ALPINE LINUX      #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Starts with a pinned version of Alpine Linux as base image. #
#    2. Updates the repositories via the package manager.           #
#    3. Installs the OpenSSH server.                                #
#    5. Sets some configuration values in '/etc/sshd_config'.       #
#    6. Creates RSA, DSA, ECDSA, and ED25519 host keys.             #
#    7. Copies 'entrypoint.sh' script to container to be run.       #
#    8. Runs the 'entrypoint.sh' script.                            #
#    9. Exposes port 22 on the container.                           #
#                                                                   #
# Note : Do not forget to expose a port on your machine if you      #
#        wish to access the SSH server and log in to it.            #
#                                                                   #
#####################################################################

# Using a base image of Alpine Linux
FROM alpine:3.11.5

# Defining ARGs for injecting metadata during build time
ARG CONFIG=/etc/ssh/sshd_config
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=1.0

# Installing OpenSSH server
RUN apk update -U --no-cache \
  && apk add --no-cache \
    openssh-server && \
  # Changing SSHD configuration file defaults
	sed -ri 's|^#?LogLevel(%s+).*|LogLevel VERBOSE|g' ${CONFIG} ; \
	sed -ri 's|^#?PasswordAuthentication(\s+).*|PasswordAuthentication yes|g' ${CONFIG} ; \
	sed -ri 's|^#?PermitRootLogin(\s+).*|PermitRootLogin no|g' ${CONFIG} ; \
	sed -ri 's|#?PermitEmptyPasswords(\s+).*|PermitEmptyPasswords no|g' ${CONFIG} ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_rsa_key|HostKey /etc/ssh/ssh_host_rsa_key|g' ${CONFIG} ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_dsa_key|HostKey /etc/ssh/ssh_host_dsa_key|g' ${CONFIG} ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ecdsa_key|HostKey /etc/ssh/ssh_host_ecdsa_key|g' ${CONFIG} ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ed25519_key|HostKey /etc/ssh/ssh_host_ed25519_key|g' ${CONFIG} ; \
  # Creating SSH host keys
	ssh-keygen -t rsa -C "RSA Host Key" -N "" -f /etc/ssh/ssh_host_rsa_key -q && \
	ssh-keygen -t dsa -C "DSA Host Key" -N "" -f /etc/ssh/ssh_host_dsa_key -q && \
	ssh-keygen -t ecdsa -C "ECDSA Host Key" -N "" -f /etc/ssh/ssh_host_ecdsa_key -q && \
	ssh-keygen -t ed25519 -C "ED25519 Host Key" -N "" -f /etc/ssh/ssh_host_ed25519_key -q \
	# Cleaning up unnecessary files
	&& rm -rf /var/cache \
	&& rm -rf /lib/apk

# Copying the 'entrypoint' script that will help configure the SSH server
COPY ./entrypoint.sh /usr/local/bin/

# Entrypoint - Run 'entrypoint.sh' script. Any command given to 'docker container run' will be added as an argument
# to the ENTRYPOINT command below. The 'entrypoint.sh' script needs to receive 'ssh' as an argument in order to set up
# the SSH server.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Exposing port 22 on the container
EXPOSE 22

# The 'ssh' CMD is required by the 'entrypoint.sh' script to set up the SSH server. 
# Any command given to the 'docker container run' will override the CMD below which
# will result in the SSH server not being started. 
CMD ["ssh"]

# Maintainer information
LABEL org.opencontainers.image.vendor="Harsha Vardhan J" \
      org.opencontainers.image.title="openssh" \
      org.opencontainers.image.authors="https://github.com/HarshaVardhanJ" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/HarshaVardhanJ/docker_files/tree/master/openssh" \
      org.label-schema.vcs-url="https://github.com/HarshaVardhanJ/docker_files/tree/master/openssh" \
      org.opencontainers.image.documentation="https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh/README.md" \
      org.opencontainers.image.source="https://github.com/HarshaVardhanJ/docker_files/blob/master/openssh/openssh-alpine/Dockerfile" \
      org.opencontainers.image.description="This Dockerfile creates an OpenSSH server listening on \
      port 22. By default, the user created is 'docker' with the same password. \
      This can be changed by passing environment variables during container run \
      time. USER can be passed for changing the default user, PASSWORD can be \
      passed for setting the password of the user. Also, an SSH public key can be \
      added via the SSH_PUBKEY variable which will enable the user to log in using \
      public-key authentication." \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.build-date=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF \
      org.label-schema.vcs-ref=$VCS_REF \
      org.opencontainers.image.version=$VERSION \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
