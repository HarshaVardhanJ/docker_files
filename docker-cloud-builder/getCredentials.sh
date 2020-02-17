#!/usr/bin/env sh
#
#: Title        : getCredentials.sh
#: Date         :	17-Feb-2020
#: Author       :	"Harsha Vardhan J" <vardhanharshaj@gmail.com>
#: Version      : 0.1
#: Description  : Script which is used to get credentials by
#                 Cloud Build in order to log in to Docker Hub.
#: Options      : None
#: Usage        :	This script is to be used in GCP Cloud Build.
################


# Wrapper function around the gcloud command used to access secrets
getCreds() {

  if [ $# -eq 2 && -n "${2}" ] ; then
    gcloud beta secrets versions access ${1} --secret="${2}"
  else
    exit 1
  fi

}

# Calling the 'getCreds' function
getCreds 1 DockerHubUserID > ./UserID
getCreds 1 DockerHubAccessToken > ./AccessToken

# End of script
