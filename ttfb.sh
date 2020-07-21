#!/bin/bash
## This script gives some useful SEO information
## about the URL provided
## REQUIRED: Put the curl-format.tmpl in the same directory as the script
##
URL="$1"
if [[ -z "$URL" ]]
  then printf "No URL specified.\n"
  exit 1
fi

# Function to get full path of called script
function getpath {
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"
}

function get {
curl -L -w "@curl-format.tmpl" -o /dev/null -s "$URL"
}

function main {
getpath
get "$URL"
cd -
}

main "$@"
