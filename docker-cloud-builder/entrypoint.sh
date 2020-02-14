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
binfmtVersion="0.7"

# Function which initialises `buildx`
buildxInitialise() {
  # Running the below command adds support for multi-arch
  # builds by setting up QEMU
  docker run --privileged linuxkit/binfmt:v${binfmtVersion} || exit 1

  # If the `buildx` executable is in PATH
  if [ $(which "${buildxCommand}") ] ; then
    # Initialise a builder and switch to it
    "${buildxCommand}" create --name multiarch-builder \
      && "${buildxCommand}" use multiarch-builder \
      && "${buildxCommand}" inspect --bootstrap
  else
    printf '%s\n' "The ${buildxCommand} could not be found in the PATH." \
      && exit 1
  fi
}

# Calling the initialisation function and passing all arguments to buildx
buildxInitialise \
  && ${buildxCommand} $@

# End of script
