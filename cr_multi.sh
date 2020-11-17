#!/usr/bin/env bash

#
# ---------------------------------------------------------------------
#

export PATH="$PATH:/usr/local/bin"

# The backups from ./config/crestic/crestic.cfg
backups=('')
source ./.config/restic/backups

command='unlock'

if [ "$1" ]; then
  command=$1
fi


for index in ${!backups[*]}; do
  crestic "${backups[$index]}" "${command}"
done

# EOF
