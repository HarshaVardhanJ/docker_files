### Dockerfile for dockerization of SSHD service on Alpine Linux. ###
#                                                                   #
#####################################################################
#       DOCKERISED SSH SERVICE BUILT ON TOP OF ALPINE LINUX         #
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
#    3. Installs the OpenSSH server.                                #
#    4. Exposes port 22 on the container.                           #
#    5. Sets some configuration values in '/etc/sshd_config'.       #
#    6. Creates RSA, DSA, ECDSA, and ED25519 host keys.             #
#    7. Creates user 'docker', changes default shell to '/bin/ash'  #
#       and adds to 'wheel' group, creates home directory, and      #
#       doesn't provide initial password for login. This is so it   #
#       can be changed next.                                        #
#    8. Changes the password of 'docker' user to 'docker'.          #
#    9. Creates '.ssh' directory in '/home/docker'.                 #
#    10. Adds 'docker' user's SSH-related configuration values.     #
#    11. Starts OpenSSH server in daemon mode.                      #
#                                                                   #
# Note : Do not forget to expose a port on your machine if you      #
#        wish to access the SSH server and log in to it.            #
#                                                                   #
#####################################################################
# Using a base image of Alpine Linux
FROM alpine:latest

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      dockerfile.github.page="https://github.com/HarshaVardhanJ/docker_files\
/blob/master/openssh-alpine/Dockerfile" \
      description="This Dockerfile creates an OpenSSH server listening on \
port 22. Only 'docker' user is allowed to log in to the server. The \
password of the 'docker' user has been changed to 'docker', and the \
shell of the 'docker' user has been changed to '/bin/ash'." \
      version="0.1"

# Defining ARG and ENV variables
ARG CONFIG=/etc/ssh/sshd_config
ENV USER="${USER:-docker}" \
	PASSWORD="${PASSWORD:-docker}" \
	SSH_PUBKEY_FILE="${SSH_PUBKEY_FILE:-/etc/ssh/ssh_host_rsa_key.pub}"

# Installing the OpenSSH server
RUN apk update ; apk add --no-cache \
	openssh-server && \
# Changing SSHD configuration file defaults
	sed -ri 's|^#?LogLevel INFO|LogLevel VERBOSE|g' ${CONFIG} ; \
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
	ssh-keygen -t ed25519 -C "ED25519 Host Key" -N "" -f /etc/ssh/ssh_host_ed25519_key -q ; \
# Copying the user-defined SSH public key
	cat ${SSH_PUBKEY_FILE} > /home/temp_authorized_keys

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
