#!/usr/bin/env sh
#
#: Title        : entrypoint.sh 
#: Date         :	13-Feb-2020
#: Author       :	"Harsha Vardhan J" <vardhanharshaj@gmail.com>
#: Version      : 0.2
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
  echo "*****Downloading binfmt:"${binfmtVersion}*****" image"
  docker run --privileged harshavardhanj/binfmt:"${binfmtVersion}" || exit 1
  echo "*****Downloading qemu-user-static image*****"
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes || exit 1

  # If the `buildx` executable is in PATH
  if [ -n "${buildxCommand}" ] ; then
    # Initialise a builder and switch to it
    echo "*****Initialising and bootstrapping builder*****"
    "${buildxCommand}" create --driver docker-container --driver-opt image=moby/buildkit:master,network=host \
      --name multiarch-builder --use \
      && "${buildxCommand}" inspect --bootstrap
  else
    printf '%s\n' "*****The executable '${buildxCommand}' could not be found in the PATH.*****" \
      && exit 1
  fi

}


# Function used to check if the pre-configured builder already exists.
# If it does, that builder is used. Else, the builder is reconfigured.
checkBuilderExistence() {
    # Name of buildx executable
    buildxCommand="$(command -v buildx)"

    echo "*****Checking if buildx builder exists*****"
    builderName="$("${buildxCommand}" inspect multiarch-builder 2>/dev/null)"
    #builderStatus="$("${buildxCommand}" inspect multiarch-builder 2>/dev/null | grep -o "running")"

    #if [[ -n "${builderName}" && -n "${builderStatus}" ]] ; then
    if [[ -n "${builderName}" ]] ; then
      echo "*****Selecting multiarch-builder*****"
      "${buildxCommand}" use --default multiarch-builder
      
      # If the builder could not be selected and used
      if [[ $? -ne 0 ]] ; then
        echo "*****Could not use multiarch-builder*****"
        exit 1
      fi
    else
      buildxInitialise \
        exit 1
    fi
}


# Main function
# This function does one of the following, depending on the argument(s)
#     * Initialises 'buildx'
#     * Initialises 'buildx' and passes all input arguments to
#       the 'docker' command
main() {
  # Name of buildx executable
  buildxCommand="$(command -v buildx)"

  # Argument which, when passed, begins ONLY the docker-buildx init process
  initialisationArgument="init"

  # If the only argument passed is the string defined in ${initialisationArgument}
  if [[ $# -eq 1 && "$1" == "${initialisationArgument}" ]] ; then
    # Initialise the buildx builder
    checkBuilderExistence
  elif [[ $# -ge 1 && "$1" != "${initialisationArgument}" ]] ; then
    # Initialise the buildx builder and then pass all arguments
    # to the buildx command
    checkBuilderExistence \
      && "${buildxCommand}" $@
  fi
}

# Calling the main function and passing all arguments to it
main $@

# End of script
