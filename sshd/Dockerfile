### Dockerfile for dockerization of SSHD service on Alpine Linux. ###
#                                                                   #
#####################################################################
#       DOCKERISED SSH SERVICE BUILT ON TOP OF ALPINE LINUX         #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################


# Using a base image of Alpine Linux
FROM alpine:latest

# Maintainer information
MAINTAINER Harsha Vardhan J "https://github.com/HarshaVardhanJ"

# Installing the OpenSSH server
RUN apk add --no-cache openssh-server

# Exposing port 22 on the container
EXPOSE 22

# Changing configuration file defaults
RUN sed -ri 's|^#?LogLevel INFO|LogLevel VERBOSE|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?PasswordAuthentication(\s+).*|PasswordAuthentication yes|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?PermitRootLogin(\s+).*|PermitRootLogin no|g' /etc/ssh/sshd_config ; \
	sed -ri 's|#?PermitEmptyPasswords(\s+).*|PermitEmptyPasswords no|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_rsa_key|HostKey /etc/ssh/ssh_host_rsa_key|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_dsa_key|HostKey /etc/ssh/ssh_host_dsa_key|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ecdsa_key|HostKey /etc/ssh/ssh_host_ecdsa_key|g' /etc/ssh/sshd_config ; \
	sed -ri 's|^#?HostKey(\s+).*/etc/ssh/ssh_host_ed25519_key|HostKey /etc/ssh/ssh_host_ed25519_key|g' /etc/ssh/sshd_config ; \
	echo "AllowUsers docker" >> /etc/ssh/sshd_config

# Creating SSH host keys
RUN ssh-keygen -t rsa -C "RSA Host Key" -N "" -f /etc/ssh/ssh_host_rsa_key -q && \
	ssh-keygen -t dsa -C "DSA Host Key" -N "" -f /etc/ssh/ssh_host_dsa_key -q && \
	ssh-keygen -t ecdsa -C "ECDSA Host Key" -N "" -f /etc/ssh/ssh_host_ecdsa_key -q && \
	ssh-keygen -t ed25519 -C "ED25519 Host Key" -N "" -f /etc/ssh/ssh_host_ed25519_key -q

# Adding user 'docker', changing password to 'docker' and creating '.ssh' directory in home folder
RUN adduser -g "Docker user for SSH login" -h /home/docker -s /bin/sh -G wheel -D docker && \
	echo "docker:docker" | chpasswd

# Configuration for user 'docker' SSH configuration
RUN mkdir -p /home/docker/.ssh ; \
	echo "StrictHostKeyChecking=no" > /home/docker/.ssh/config; \
	echo "UserKnownHostsFile=/dev/null" >> /home/docker/.ssh/config

# Starting the OpenSSH server
CMD ["/usr/sbin/sshd", "-D"]
