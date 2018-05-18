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
#    3. Installs the OpenSSH server and 'bash'.                     #
#    4. Exposes port 22 on the container.                           #
#    5. Sets some configuration values in '/etc/sshd_config'.       #
#    6. Creates RSA, DSA, ECDSA, and ED25519 host keys.             #
#    7. Changes the default shell of 'root' user to '/bin/bash'.    #
#    8. Changes the password of 'root' user to 'docker'.            #
#    9. Creates '.ssh' directory in '/root'.                        #
#    10. Adds 'root' user's SSH-related configuration values.       #
#    11. Starts OpenSSH server in daemon mode.                      #
#                                                                   #
# Note : Do not forget to expose a port on your machine if you      #
#        wish to access the SSH server and log in to it.            #
#                                                                   #
#####################################################################

# Using a base image of Alpine Linux
FROM alpine:latest

# Maintainer information
MAINTAINER Harsha Vardhan J "https://github.com/HarshaVardhanJ"

# Installing the OpenSSH server and 'bash' shell
RUN apk update ; \
	apk add --no-cache openssh-server ; \
	apk add --no-cache bash

# Exposing port 22 on the container
EXPOSE 22

# Changing OpenSSH server configuration file defaults
RUN sed -ri 's|^#?LogLevel INFO|LogLevel VERBOSE|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?PasswordAuthentication(\s+).*|PasswordAuthentication yes|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?PermitRootLogin(\s+).*|PermitRootLogin yes|g' /etc/ssh/sshd_config ; \
	sed -ri 's|#?PermitEmptyPasswords(\s+).*|PermitEmptyPasswords no|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_rsa_key|HostKey /etc/ssh/ssh_host_rsa_key|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_dsa_key|HostKey /etc/ssh/ssh_host_dsa_key|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ecdsa_key|HostKey /etc/ssh/ssh_host_ecdsa_key|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ed25519_key|HostKey /etc/ssh/ssh_host_ed25519_key|g' /etc/ssh/sshd_config ; \
	echo "AllowUsers root" >> /etc/ssh/sshd_config

# Creating SSH host keys
RUN ssh-keygen -t rsa -C "RSA Host Key" -N "" -f /etc/ssh/ssh_host_rsa_key -q && \
	ssh-keygen -t dsa -C "DSA Host Key" -N "" -f /etc/ssh/ssh_host_dsa_key -q && \
	ssh-keygen -t ecdsa -C "ECDSA Host Key" -N "" -f /etc/ssh/ssh_host_ecdsa_key -q && \
	ssh-keygen -t ed25519 -C "ED25519 Host Key" -N "" -f /etc/ssh/ssh_host_ed25519_key -q

# Changing shell of 'root' user to '/bin/bash' and changing password of 'root'
RUN sed -ri 's|(.*)/bin/ash$|\1/bin/bash|g' /etc/passwd && \
	echo "root:docker" | chpasswd

# Configuration for user 'docker' SSH configuration
RUN mkdir -p /root/.ssh ; \
	echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
	echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config

# Starting the OpenSSH server
CMD ["/usr/sbin/sshd", "-D"]
