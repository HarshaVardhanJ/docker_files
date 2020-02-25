#!/usr/bin/env sh
#
#: Title        : entrypoint.sh 
#: Date         :	13-Feb-2020
#: Author       :	"Harsha Vardhan J" <vardhanharshaj@gmail.com>
#: Version      : 0.1
#: Description  : Used to initialise a Docker image with support
#                 for `buildx` added.
#: Options      : None
#: Usage        :	The script will be added the container image
#                 and run as the ENTRYPOINT command.
################

# Variable that contains name of `buildx` executable
buildxCommand="docker-buildx"

# Variable that contains name of non-root user account which
# will be used to run `docker-buildx` commands
nonRootUser="docker"

# Variable which contains the path to the Docker socket
dockerSocket="/var/run/docker.sock"

# Function which initialises `buildx`
#
buildxInitialise() {
  # Running the below commands adds support for multi-arch
  # builds by setting up QEMU
  docker run --privileged harshavardhanj/binfmt:testing || exit 1
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

  # If the `buildx` executable is in PATH
  if [ $(which "${buildxCommand}") ] ; then
    # Initialise a builder and switch to it
    "${buildxCommand}" create --driver docker-container --name multiarch-builder --use \
      && "${buildxCommand}" inspect --bootstrap
      #&& "${buildxCommand}" use multiarch-builder \
  else
    printf '%s\n' "The executable '${buildxCommand}' could not be found in the PATH." \
      && exit 1
  fi
}


# Function which grants group permission of Docker socket to the
# non-root user
#
socketOwnership() {
  # If the file defined by $dockerSocket is a socket
 if [ -S "${dockerSocket}" ] ; then
   # Get group which owns the Docker socket
   userGroup="$(stat -c '%G' "${dockerSocket}")"

   # Add non-root user to group which owns Docker socket
   addgroup "${nonRootUser}" "${userGroup}" || exit 1
 else
    printf '%s\n' "Could not find '${dockerSocket}'" >&2 \
      && exit 1
 fi
}


# Main function which checks if the user defined in $nonRootUser exists.
# If the user exists, first the buildxInitialise function is called, then
# the socketOwnership function is called. Finally the buildx command is
# run as non-root user with all arguments being passed to it.
#
main() {
  # If user defined in '$nonRootUser' user exists
  if [ -n "$(id -u "${nonRootUser}")" ] ; then
    buildxInitialise \
      && socketOwnership \
      && exec su-exec "${nonRootUser}" "${buildxCommand}" $@
  else
    printf '%s\n' "User '${nonRootUser}' does not exist. Exiting." >&2 \
      && exit 1
  fi
}


# Calling the main function and passing all arguments to it
main $@

# End of script
