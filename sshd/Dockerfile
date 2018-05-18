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

# Starting the OpenSSH server
CMD ["/usr/bin/sshd", "-D"]
