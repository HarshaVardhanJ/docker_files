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
  # Running the below command adds support for multi-arch
  # builds by setting up QEMU
  printf '%s\n' "***********Running binfmt command**************"
  docker run --privileged harshavardhanj/binfmt:testing || exit 1

  printf '%s\n' "***********Running qemu-user-static command**************"
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

  # If the `buildx` executable is in PATH
  if [ $(which "${buildxCommand}") ] ; then
    # Initialise a builder and switch to it
    printf '%s\n' "***********Builder Init**************"
    "${buildxCommand}" create --name multiarch-builder \
      && "${buildxCommand}" use multiarch-builder \
      && "${buildxCommand}" inspect --bootstrap
  else
    printf '%s\n' "The ${buildxCommand} could not be found in the PATH." \
      && exit 1
  fi
}


# Function which grants group permission of Docker socket to the
# non-root user
#
socketOwnership() {

 if [ -S "${dockerSocket}" ] ; then
   # Get GID which owns the Docker socket
   userGid=$(stat -c '%g' "${dockerSocket}")

   # Get group which owns the Docker socket
   userGroup=$(stat -c '%G' "${dockerSocket}")

   # Add the GID of group who is owner of the Docker socket
   # to the non-root user
   addgroup -g "${userGid}" "${nonRootUser}" "${userGroup}"
 else
    printf '%s\n' "Could not find ${dockerSocket}" >&2 \
      && exit 1
 fi

}


# Main function which checks if the user defined in $nonRootUser exists.
# If the user exists, buildxInitialise function is called, and buildx is
# run as non-root user with all arguments being passed to it.
#
main() {

  printf '%s\n' "***********Main Function**************"
  # If 'docker' user exists
  if [ -n "$(id -u "${nonRootUser}")" ] ; then
    buildxInitialise \
      && socketOwnership \
      && exec su-exec "${nonRootUser}" "${buildxCommand}" $@
  else
    printf '%s\n' "User 'docker' does not exist. Exiting." >&2 \
      && exit 1
  fi

}

# Calling the initialisation function and passing all arguments to buildx
#buildxInitialise \
#  && ${buildxCommand} $@


# Calling the main function and passing all arguments to it
main $@

# End of script
