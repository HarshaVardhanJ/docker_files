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
  buildxCommand="$(command -v buildx)"

  # Variable that pins the binfmt image version
  binfmtVersion="latest"

  # Running the below command adds support for multi-arch
  # builds by setting up QEMU
  echo "Downloading binfmt:"${binfmtVersion}" image"
  docker run --privileged harshavardhanj/binfmt:"${binfmtVersion}" || exit 1
  echo "Downloading qemu-user-static image"
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes || exit 1

  # If the `buildx` executable is in PATH
  if [ -n "${buildxCommand}" ] ; then
    # Initialise a builder and switch to it
    echo "Initialising and bootstrapping builder"
    "${buildxCommand}" create --driver docker-container --driver-opt image=moby/buildkit:master,network=host \
      --name multiarch-builder --use \
      && "${buildxCommand}" inspect --bootstrap
  else
    printf '%s\n' "The executable '${buildxCommand}' could not be found in the PATH." \
      && exit 1
  fi

}


# Function which checks if a builder instance has already been set up.
# If it has, that instance is used. Else, buildxInitialise function is
# called.
checkBuilderExistence() {
  # Variable that contains the path to the buildx executable
  buildxCommand="$(command -v buildx)"

  # If the variable is not an empty string
  if [ -n "${buildxCommand}" ] ; then
    # Variables that contain strings which are being searched for in the output
    # of the 'buildx inspect' command
    echo "Checking if buildx builder exists"
    builderNameCheck="$("${buildxCommand}" inspect 2>/dev/null | grep -o "multiarch-builder")"
    echo "Checking if buildx builder is running"
    builderStatusCheck="$("${buildxCommand}" inspect 2>/dev/null | grep -o "running")"

    # If either of the variables are not empty strings, meaning if
    # a builder instance has already been set up
    #if [[ -n "${builderNameCheck}" || -n "${builderStatusCheck}" ]] ; then
    if [[ -n "${builderNameCheck}" ]] ; then
      echo "Selecting pre-existing builder"
      "${buildxCommand}" use multiarch-builder \
        || exit 1
    else
      buildxInitialise \
        || exit 1
    fi
  # If buildx executable could not be found in PATH
  else
    printf '%s\n' "Could not find buildx executable." \
      && exit 1
  fi
}


# Main function
# This function does one of the following, depending on the argument(s)
#     * Initialises 'buildx'
#     * Initialises 'buildx' and passes all input arguments to
#       the 'docker' command
main() {
  # Name of docker executable
  buildxCommand="$(command -v buildx)"

  # Argument which, when passed, begins ONLY the docker-buildx init process
  initialisationArgument="init"

  # If the only arguments passed IS the string defined in ${initialisationArgument}
  if [[ $# -eq 1 && "$1" == "${initialisationArgument}" ]] ; then
    #checkBuilderExistence
    buildxInitialise
  elif [[ $# -ge 1 && "$1" != "${initialisationArgument}" ]] ; then
    #checkBuilderExistence \
    buildxInitialise \
      && "${buildxCommand}" $@
  fi
}

# Calling the main function and passing all arguments to it
main $@

# End of script
