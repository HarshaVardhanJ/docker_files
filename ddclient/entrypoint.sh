#!/usr/bin/env sh

ddclient_setup() {
  ddclientUser="ddclient"
  ddclientGroup="ddclient"
  ddclientUID=1000
  ddclientGID=1000

  # Create group `ddclient`
  echo "Adding ddclient group"
  addgroup -S -g "${ddclientGID}" "${ddclientGroup}"
  echo "Added ddclient group"

  # Create system user `ddclient`
  echo "Adding ddclient user"
  adduser -H -g "User account for ddclient" -s /bin/nologin -G "${ddclientGroup}" -u "${ddclientUID}" -S -D "${ddclientUser}"
  echo "Added ddclient user"

  # Change ownership on files related to `ddclient`
  echo "Changing ownership of /etc/ddclient to user ddclient"
  chown -R "${ddclientUser}":"${ddclientGroup}" /etc/ddclient
  echo "Changed ownership of /etc/ddclient to user ddclient"
  echo "Changing ownership of /var/cache/ddclient to user ddclient"
  chown -R "${ddclientUser}":"${ddclientGroup}" /var/cache/ddclient
  echo "Changed ownership of /var/cache/ddclient to user ddclient"

}

if [ "$1" = "ddclient" ] ; then
  # Calling the `ddclient_setup` function
  ddclient_setup

  # Running ddclient
  echo "Running ddclient process"
  exec /usr/bin/ddclient -verbose -file /etc/ddclient/ddclient.conf -daemon 300 -pid /var/run/ddclient.pid
fi

# Passing all input arguments
exec "$@"
