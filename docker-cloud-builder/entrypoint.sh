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
  docker run --privileged harshavardhanj/binfmt:testing || exit 1
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

  # If the `buildx` executable is in PATH
  if [ "$(command -v "${buildxCommand}")" ] ; then
    # Initialise a builder and switch to it
    "${buildxCommand}" create --driver docker-container --driver-opt image=moby/buildkit:master,network=host \
      --name multiarch-builder --use \
      && "${buildxCommand}" inspect --bootstrap
  else
    printf '%s\n' "The executable '${buildxCommand}' could not be found in the PATH." \
      && exit 1
  fi
}

# Main function
main() {
  # Calling the initialisation function and passing all arguments to buildx
  buildxInitialise \
    && "${buildxCommand}" $@
}

# Calling the main function and passing all arguments to it
main $@

# End of script
