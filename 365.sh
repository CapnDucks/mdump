#!/usr/bin/env bash
# This script can clean up files that were last accessed over 365 days ago.
# To test, `touch -a -m -t 1801010000 ./testfile`
# then `scriptname .`


USAGE="Usage: $0 dir1 dir2 dir3 ... dir(N)"

if [ $# == 0 ]; then
	printf "$USAGE\n"
	exit 0 # It is not an error to ask for help
fi
# Loop through the number of supplied arguments until we get to 0
while (( $# )); do
# If `ls -l` on the dir name gives nothing then dir is empty
if [[ $(ls -l "$1") == "" ]]; then
	printf "Empty directory, nothing to be done.\n"
# Otherwise, use find to print and delete files whose ACCESS times are greater than 365 days
  else
	find "$1" -type f -a -atime +365 -print -delete
fi
# throw away the next argument passed to the script on the left
shift
# End loop
done
