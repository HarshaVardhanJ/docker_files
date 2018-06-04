#!/usr/bin/env sh

if [ "$1" == "ssh" ]
then
	USER_HOME="$( echo "/home/"${USER}"" )"

	# Creating user (default - 'docker') and changing password (default -  'docker')
	if [ "$(id -u "${USER}")" != '0' ]
	then
		adduser -g "Docker user for SSH login" -h "${USER_HOME}" -s /bin/ash -G wheel -D "${USER}" && \
		echo ""${USER}":"${PASSWORD}"" | chpasswd && \
		echo "AllowUsers "${USER}"">> /etc/ssh/sshd_config
	fi

	# Creating hidden directory '.ssh' in user's home directory and configuring user's SSH file.
	if [ -d "${USER_HOME}" ]
	then
		mkdir -p "${USER_HOME}"/.ssh && \
		echo "StrictHostKeyChecking=no" > "${USER_HOME}"/.ssh/config && \
		echo "UserKnownHostsFile=/dev/null" >> "${USER_HOME}"/.ssh/config
	fi

	# If temporary public key file exists, append the contents to the user's 'authorized_keys' file
	if [ -f /home/temp_authorized_keys ]
	then
		cat /home/temp_authorized_keys >> "${USER_HOME}"/.ssh/authorized_keys && \
		rm -f /home/temp_authorized_keys
	fi

	exec /usr/sbin/sshd -D
fi

# Executing any argument passed to this script. This is useful to run the container in interactive mode.
exec "$@"

################## End of script
