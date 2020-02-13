#!/usr/bin/env sh
#
#: Title        : entrypoint.sh 
#: Date         :	13-Feb-2020
#: Author       :	"Harsha Vardhan J" <vardhanharshaj@gmail.com>
#: Version      : 
#: Description  : Used to initialise a Docker image
#                 
#                 
#                 
#                 
#: Options      : 
#: Usage        :	
################

# Variable that contains name of `buildx` executable
buildxCommand="docker-buildx"

# Function which initialises `buildx`
buildxInitialise() {
  # If the `buildx` executable is in PATH
  if [ $(which "${buildxCommand}") ] ; then
    # Initialise a builder and switch to it
    buildxCommand create --use --name multiarch-builder
  else
    printf '%s\n' "The ${buildxCommand} could not be found in the PATH." \
      && exit 1
  fi
}

# Main function which calls the buildx initialisation function
main() {

  # Calling the buildx initialiser function AND passing all arguments
  # to the `buildx` executable
  buildxInitialise \
    && buildxCommand "$@"

}

# Calling the main function and passing all arguments to it
main "$@"

# End of script
