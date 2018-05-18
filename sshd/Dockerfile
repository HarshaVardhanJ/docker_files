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

#Changing configuration file defaults
RUN sed -ri 's/^#?LogLevel INFO/LogLevel VERBOSE/g' /etc/ssh/sshd_config ; \
	sed -ri 's/^#?PasswordAuthentication(\s+).*/PasswordAuthentication yes/g' /etc/ssh/sshd_config ; \
	sed -ri 's/^#?PermitRootLogin(\s+).*/PermitRootLogin no/g' /etc/ssh/sshd_config ; \
	sed -ri 's/#?PermitEmptyPasswords(\s+).*/PermitEmptyPasswords no/g' /etc/ssh/sshd_config ; \
	echo "AllowUsers docker" >> /etc/ssh/sshd_config

# Adding user 'docker', changing password to 'docker' and creating '.ssh' directory in home folder
RUN useradd -c "Docker Account for SSH" -m -s /bin/bash -G wheel docker && \
	echo "docker:docker" | chpasswd

# Creating hidden directory '.ssh' in 'docker' user's home directory
#RUN mkdir -p /home/docker/.ssh

# Starting the OpenSSH server
CMD ["/usr/bin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]
