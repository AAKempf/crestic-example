#!/usr/bin/env bash

# crestic, uses /.config/crestic/crestric.cfg
# ---------------------------------------------------------------------
#

export PATH="$PATH:/usr/local/bin"

now_date=$(date +'%Y-%m-%d')
prune_date=$(date -dsunday +'%Y-%m-%d')

# The backups from ./config/crestic/crestic.cfg
backups=('')
source ./.config/restic/backups

for index in ${!backups[*]}; do

  crestic ${backups[$index]} forget

    if [ "$now_date" == "$prune_date" ]; then
      crestic ${backups[$index]} prune
    fi

done

# EOF
