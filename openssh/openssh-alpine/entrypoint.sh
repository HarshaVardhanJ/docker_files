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
  variableName="$1"
  fileVariable="${variableName}_FILE"
  def="${2:-}"

	if [ "$( echo "\$${variableName:-}" )" = "" ] && [ "$( echo "\$${fileVariable:-}" )" = "" ] ; then
        echo >&2 "error: both ${variableName} and ${fileVariable} are set (but are exclusive)"
        exit 1
  fi

  val="$def"

	if [  "$( echo "\$${variableName:-}" )" != "" ] ; then
        val="$( eval echo "\$${variableName:-}" )"
	elif [ "$( echo "\$${fileVariable}" )" != "" ] ; then
        val="$( eval cat "\$${fileVariable}" )"
  fi

  export "${variableName}"="${val}"
  unset "${fileVariable}"
}

# Function used for user creation and other allied tasks
user_setup() {

  file_env 'USER'
  file_env 'PASSWORD'

  # Creating user (default - 'docker') and changing password (default -  'docker')
  if [ "$(id -u "${USER:-docker}" 2>/dev/null)" != "0" ] ; then
		USER_HOME="$( eval echo "/home/${USER:-docker}" )"
		adduser -g "Docker user for SSH login" -h "${USER_HOME}" -s /bin/ash -D "${USER:-docker}"
	elif [ "$(id -u "${USER:-docker}" 2>/dev/null)" = "0" ] ; then
		USER_HOME="$( eval echo ~"${USER:-docker}" )"
		echo "Root login is prohibited. Changing to 'allowed'."
		echo "It is recommended that you use SSH keys to login as 'root'."
		echo "To use SSH keys, use the SSH_PUBKEY="$(cat testkey.pub)" option as an environment variable."
		sed -ri 's|^#?PermitRootLogin(\s+).*|PermitRootLogin yes|g' /etc/ssh/sshd_config
	else
		USER_HOME="$( eval echo ~"${USER:-docker}" )"
	fi

	echo "AllowUsers ${USER:-docker}">> /etc/ssh/sshd_config
	echo "${USER:-docker}:${PASSWORD:-docker}" | chpasswd

	# Creating hidden directory '.ssh' in user's home directory and configuring user's SSH file.
	if [ -d "${USER_HOME}" ] ; then
		mkdir -p "${USER_HOME}"/.ssh && \
		echo "StrictHostKeyChecking=no" > "${USER_HOME}"/.ssh/config ; \
		echo "UserKnownHostsFile=/dev/null" >> "${USER_HOME}"/.ssh/config
	fi

	# If SSH public key is provided by the user, append the contents to the user's 'authorized_keys' file
	file_env 'SSH_PUBKEY'
	if [ "${SSH_PUBKEY}" ] ; then
		touch "${USER_HOME}"/.ssh/authorized_keys ; \
		echo "${SSH_PUBKEY}" >> "${USER_HOME}"/.ssh/authorized_keys
	fi

}


# Main function
main() {

  # Calling the 'user_setup' function
  user_setup || exit 1

  if [ "$1" = "ssh" ] ; then
    exec /usr/sbin/sshd -D
  else
    exec "$@"
  fi

}

# Calling the main function
main "$@"

################## End of script
