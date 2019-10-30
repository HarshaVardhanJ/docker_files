## Dockerfile for dockerization of SSHD service on Debian Jessie.  ##
#                                                                   #
#####################################################################
#       DOCKERISED SSH SERVICE BUILT ON TOP OF DEBIAN JESSIE        #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Imports the latest base image of Debian Stretch.             #
#    2. Updates the repositories via the package manager.           #
#    3. Installs the OpenSSH server.                                #
#    5. Sets some configuration values in '/etc/sshd_config'.       #
#    6. Create /var/run/sshd directory. This needs to be done       #
#       due to a bug in OpenSSH package in Debian Jessie.           #
#       Look up 'Bug#823659: openssh-server: Missing privilege      #
#       separation directory: /var/run/sshd' for more info.         #
#    7. Delete auto-generated SSH host keys and create new ones.    #
#    7. Copies 'entrypoint.sh' script to container to be run.       #
#    8. Runs the 'entrypoint.sh' script                             #
#    9. Exposes port 22 on the container.                           #
#                                                                   #
# Note : Do not forget to expose a port on your machine if you      #
#        wish to access the SSH server and log in to it.            #
#                                                                   #
#####################################################################
# Using a base image of debian:stretch-slim
FROM debian:stretch-slim

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      dockerfile.github.page="https://github.com/HarshaVardhanJ/docker_files\
/blob/master/openssh/openssh-debian/Dockerfile" \
      description="This Dockerfile creates an OpenSSH server listening on \
port 22. By default, the user created is 'docker' with the same password. \
This can be changed by passing environment variables during container run \
time. USER can be passed for changing the default user, PASSWORD can be \
passed for setting the password of the user. Also, an SSH public key can be \
added via the SSH_PUBKEY variable which will enable the user to log in using \
public-key authentication." \
      version="1.0"

# Defining ARG and ENV variables
ARG CONFIG=/etc/ssh/sshd_config

# Installing bash and OpenSSH server and cleanup
RUN apt-get update ; apt-get install -y --no-install-recommends \
	openssh-server && \
	apt-get -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
# Changing SSHD configuration file defaults
	sed -ri 's|^#?LogLevel INFO|LogLevel VERBOSE|g' ${CONFIG} ; \
	sed -ri 's|^#?PasswordAuthentication(\s+).*|PasswordAuthentication yes|g' ${CONFIG} ; \
	sed -ri 's|^#?PermitRootLogin(\s+).*|PermitRootLogin no|g' ${CONFIG} ; \
	sed -ri 's|#?PermitEmptyPasswords(\s+).*|PermitEmptyPasswords no|g' ${CONFIG} ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_rsa_key|HostKey /etc/ssh/ssh_host_rsa_key|g' ${CONFIG} ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_dsa_key|HostKey /etc/ssh/ssh_host_dsa_key|g' ${CONFIG} ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ecdsa_key|HostKey /etc/ssh/ssh_host_ecdsa_key|g' ${CONFIG} ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ed25519_key|HostKey /etc/ssh/ssh_host_ed25519_key|g' ${CONFIG} ; \
	mkdir /var/run/sshd && \
	rm -f /etc/ssh/ssh_host* && \
# Creating SSH host keys
	ssh-keygen -t rsa -C "RSA Host Key" -N "" -f /etc/ssh/ssh_host_rsa_key -q && \
	ssh-keygen -t dsa -C "DSA Host Key" -N "" -f /etc/ssh/ssh_host_dsa_key -q && \
	ssh-keygen -t ecdsa -C "ECDSA Host Key" -N "" -f /etc/ssh/ssh_host_ecdsa_key -q && \
	ssh-keygen -t ed25519 -C "ED25519 Host Key" -N "" -f /etc/ssh/ssh_host_ed25519_key -q

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
# will result in the SSH server not being set up. 
CMD ["ssh"]
