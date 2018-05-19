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
#    3. Installs 'bash' and the OpenSSH server.                     #
#    4. Sets some configuration values in '/etc/sshd_config'.       #
#    5. Creates RSA, DSA, ECDSA, and ED25519 host keys.             #
#    6. Changes the default shell of 'root' user to '/bin/bash'.    #
#    7. Changes the password of 'root' user to 'docker'.            #
#    8. Creates '.ssh' directory in '/root'.                        #
#    9. Adds 'root' user's SSH-related configuration values.        #
#    10. Exposes port 22 on the container.                          #
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
/blob/bash-with-root/openssh-alpine/Dockerfile" \
	  description="This Dockerfile creates an OpenSSH server listening on \
port 22. Only root is allowed to log in to the server. The password \
of the root user has been changed to 'docker', and the shell of the \
root user has been changed to '/bin/bash'." \
	  version="0.1"

# Installing the OpenSSH server and 'bash' shell
RUN apk update ; \
	apk add --no-cache bash ; \
	apk add --no-cache openssh-server && \
# Changing OpenSSH server configuration file defaults
	sed -ri 's|^#?LogLevel INFO|LogLevel VERBOSE|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?PasswordAuthentication(\s+).*|PasswordAuthentication yes|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?PermitRootLogin(\s+).*|PermitRootLogin yes|g' /etc/ssh/sshd_config ; \
	sed -ri 's|#?PermitEmptyPasswords(\s+).*|PermitEmptyPasswords no|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_rsa_key|HostKey /etc/ssh/ssh_host_rsa_key|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_dsa_key|HostKey /etc/ssh/ssh_host_dsa_key|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ecdsa_key|HostKey /etc/ssh/ssh_host_ecdsa_key|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ed25519_key|HostKey /etc/ssh/ssh_host_ed25519_key|g' /etc/ssh/sshd_config ; \
	echo "AllowUsers root" >> /etc/ssh/sshd_config ; \
# Creating SSH host keys
	ssh-keygen -t rsa -C "RSA Host Key" -N "" -f /etc/ssh/ssh_host_rsa_key -q && \
	ssh-keygen -t dsa -C "DSA Host Key" -N "" -f /etc/ssh/ssh_host_dsa_key -q && \
	ssh-keygen -t ecdsa -C "ECDSA Host Key" -N "" -f /etc/ssh/ssh_host_ecdsa_key -q && \
	ssh-keygen -t ed25519 -C "ED25519 Host Key" -N "" -f /etc/ssh/ssh_host_ed25519_key -q ; \
# Changing shell of 'root' user to '/bin/bash' and changing password of 'root'
	sed -ri 's|(.*)/bin/ash$|\1/bin/bash|g' /etc/passwd && \
	echo "root:docker" | chpasswd ; \
# Configuration for user 'docker' SSH configuration
	mkdir -p /root/.ssh ; \
	echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
	echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config

# Exposing port 22 on the container
EXPOSE 22

# Entrypoint - Run SSHD server in daemon mode. Any command given to 'docker container run' will be added as an argument
# to the ENTRYPOINT command below.
ENTRYPOINT /usr/sbin/sshd -D

# Any command given to the 'docker container run' will override the CMD below. 
#CMD ["/bin/ash"]

# Starting the OpenSSH server
#CMD ["/usr/sbin/sshd", "-D"]
