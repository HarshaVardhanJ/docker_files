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

	if [ -z "\$${var:+}" ] && [ -z "\$${fileVar:+}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi

    val="$def"

    if [ -z "\$$var" ]; then
		val=$( eval echo "\$$var" )
    elif [ -z "\$$fileVar" ]; then
        val="$( eval cat "\$$fileVar" )"
    fi

    export "$var"="$val"
    unset "$fileVar"
}

file_env 'USER' 'docker'
file_env 'PASSWORD' 'docker'
