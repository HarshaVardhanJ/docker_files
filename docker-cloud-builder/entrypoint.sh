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


# Function which initialises `buildx`
buildxInitialise() {
  # Variable that contains name of `buildx` executable
  buildxCommand="docker-buildx"

  # Variable that pins the binfmt image version
  binfmtVersion="latest"

  # Running the below command adds support for multi-arch
  # builds by setting up QEMU
  docker run --privileged harshavardhanj/binfmt:"${binfmtVersion}" || exit 1
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes || exit 1

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

  # Command which "installs" buildx so that when `docker build` is called,
  # 'buildx' is automatically used instead of the old builder.
  "${buildxCommand}" install || exit 1
}


# Main function
# This function does one of the following, depending on the argument(s)
#     * Initialises 'buildx'
#     * Initialises 'buildx' and passes all input arguments to
#       the 'docker' command
main() {
  # Name of docker executable
  dockerCommand="docker"

  # Argument which, when passed, begins ONLY the docker-buildx init process
  initialisationArgument="init"

  # If the only arguments passed IS the string defined in ${initialisationArgument}
  if [ $# -eq 1 && "$1" = "${initialisationArgument}" ] ; then
    buildxInitialise
  # If multiple arguments are passed and the first one is NOT the string defined in
  # ${initialisationArgument}
  elif [ $# -gt 1 && "$1" != "${initialisationArgument}" ] ; then
    buildxInitialise \
      && "${dockerCommand}" "$@"
  else
    printf '%s\n' "Incorrect argument(s) '$@' received. Expecting either '${initialisationArgument}'\
      or other arguments which '${dockerCommand}' accepts." >&2 \
      && exit 1
  fi
}

# Calling the main function and passing all arguments to it
main "$@"

# End of script
