#!/usr/bin/env sh

#set -Eueo pipefail 
set -u
# usage: file_env VAR [DEFAULT]
#     ie: file_env 'XYZ_DB_PASSWORD' 'example'
#     (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#     "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
# To pass files containing the needed information, you will need to do it via secrets for which
# the machine will need to be initialized as part of a swarm. Else, pass the contents of the file as follows:
#
#    docker container run ...... -e USER="$(cat user.file)" -e PASSWORD="$(cat password.file)" -e SSH_PUBKEY="$(cat ssh_key.pub)" image:latest
# The function below was taken from the 'entrypoint.sh' script that the Postgres Dockerfile refers to. 
file_env() {
    var="$1"
    fileVar="${var}_FILE"
    def="${2:-}"

	if [ "$( echo "\$${var:-}" )" = "" ] && [ "$( echo "\$${fileVar:-}" )" = "" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi

    val="$def"

    if [ "$( echo "\$${var}" )" != "" ]; then
        val="$( eval echo "\$${var}" )"
    elif [ "$( echo "\$${fileVar}" )" != "" ]; then
        val="$( eval cat "\$${fileVar}" )"
    fi

    export "${var}"="${val}"
    unset "${fileVar}"
}


if [ "$1" = "ssh" ]
then
    file_env 'USER' 'docker'
    file_env 'PASSWORD' 'docker'

    # Creating user (default - 'docker') and changing password (default -  'docker')
    if [ "$(id -u "${USER}")" != "0" ]
	then
		USER_HOME="$( eval echo "/home/${USER}" )"
		adduser -g "Docker user for SSH login" -h "${USER_HOME}" -s /bin/sh -G wheel -D "${USER}" && \
		echo "${USER}:${PASSWORD}" | chpasswd && \
		echo "AllowUsers ${USER}">> /etc/ssh/sshd_config
	elif [ "${USER}" = "root" ]
	then
		echo "Root login is prohibited. Changing to 'allowed'."
		sed -ri 's|^#?PermitRootLogin(\s+).*|PermitRootLogin yes|g' /etc/ssh/sshd_config
	else
		echo "${USER}:${PASSWORD}" | chpasswd && \
		echo "AllowUsers ${USER}">> /etc/ssh/sshd_config
	fi

	# Creating hidden directory '.ssh' in user's home directory and configuring user's SSH file.
	if [ -d "${USER_HOME}" ]
	then
		mkdir -p "${USER_HOME}"/.ssh && \
		echo "StrictHostKeyChecking=no" > "${USER_HOME}"/.ssh/config ; \
		echo "UserKnownHostsFile=/dev/null" >> "${USER_HOME}"/.ssh/config
	fi

	# If SSH public key is provided by the user, append the contents to the user's 'authorized_keys' file
	file_env 'SSH_PUBKEY'
	if [ "${SSH_PUBKEY}" ]
	then
		touch "${USER_HOME}"/.ssh/authorized_keys ; \
		echo "${SSH_PUBKEY}" >> "${USER_HOME}"/.ssh/authorized_keys
	fi

	exec /usr/sbin/sshd -D
fi

# Executing any argument passed to this script. This is useful to run the container in interactive mode.
exec "$@"

################## End of script
