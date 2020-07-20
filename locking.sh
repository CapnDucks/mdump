#!/usr/bin/env bash
# Not really a script, but remembering how to do a LOCKFILE
# Define our lockfile
LOCKFILE="/tmp/lock.lock"

function lockexists {
# If lockfile exists then exit with an error
[ -f "$LOCKFILE" ] &&
printf "Error: Lockfile found in $LOCKFILE" &&
exit 1
}

function unlockme {
# Remove lockfile if exit successful
trap "{ rm -f $LOCKFILE ; exit 255; }" EXIT
}

function lockme {
# Create lockfile
  touch $LOCKFILE
}

function stuff {
# Do stuff
  printf "I created a file $LOCKFILE\n"
  ls -lah "$LOCKFILE"
  printf "Then I removed it\n"
# End do stuff
exit 0
}

function main {
lockexists
unlockme
lockme
stuff
}

main "$@"
