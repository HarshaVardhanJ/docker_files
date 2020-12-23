#!/usr/bin/env sh
#
#: Title        : entrypoint.sh
#: Date         : 24-Oct-2020
#: Author       : "Harsha Vardhan J" <vardhanharshaj@gmail.com>
#: Version      : 0.1
#: Description  : Script used to update certificates and start
#                 the CoreDNS process.
#                 
#                 
#                 
#: Options      : 
#: Usage        :	
################

# -u  Treat unset variables as an error when substituting.
# -o  option-name
#     pipefail     the return value of a pipeline is the status of
#                 the last command to exit with a non-zero status,
#                 or zero if no command exited with a non-zero status
set -uo pipefail

# checkIfSet checks if a certain variable has been set.
# The first argument is the variable which is to be checked.
# The second argument is the value that it should be set to
# if its value has not been set previously.
#
# Input  :  checkIfSet VARIABLE_NAME "Value to be set"
# Output :  None.
checkIfSet() {

  # If number of arguments = 1
  if [ $# -eq 1 ] ; then
    # If first argument is a variable that is set
    [ -z "\$${1-""}" ] && return 1
  # If number of arguments = 2
  elif [ $# -eq 2 ] ; then
    # If first argument is a variable that is not set
    { [ -n "\$${1-""}" ] || [ -n "$( eval echo "\$${1}" )" ] ;} || \
      export "$1"="$2"
  else
    printf '%s\n' "checkIfSet : Incorrect number of arguments : $#" 1>&2
    return 1
  fi
  # Exit if number of arguments is not equal to 2
  #[ $# -eq 2 ] || { printf '%s\n' "checkIfSet : Incorrect number of arguments : $#" 1>&2 && return 1 ;}

  # Export variable if it is not set
  #[ -n "$( eval echo "\$${1}" )" ] || export "$1"="$2"
  #{ [ -n "${1+""}" ] || [ -n "$( eval echo "\$${1}" )" ] ;} || export "$1"="$2"
}

# Include all tests in this function
testFunction() {
  export TEST_VARIABLE_1="test variable 1"
  checkIfSet TEST_VARIABLE_1

  #CheckingCommand=$(checkIfSet TEST_VARIABLE_0)
  #[ $(checkIfSet TEST_VARIABLE_0) ] || printf '\t%s\n' "Error encountered" 1>&2
  checkIfSet TEST_VARIABLE_1 "test variable 3"
  checkIfSet TEST_VARIABLE_2 "test variable 2"

  for variableName in TEST_VARIABLE_1 TEST_VARIABLE_2 ; do
    echo "${variableName}=$( eval echo "\$${variableName}" )"
  done
}

testFunction

# End of script
