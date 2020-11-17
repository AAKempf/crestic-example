#!/usr/bin/env bash
#
# restic backup
#
# Using crestic as central configuration container for restic
#

# Config

# Get the path to crestic for the cronjob
export PATH="$PATH:/usr/local/bin"

# needed for logging
SECONDS=0
date_start=$(date +'%F %X')
logfile='/var/log/restic_backup.log'
logfile='./restic_backup.log'

# The defined backups
backups=('')
source ./.config/restic/backups

# Start
/bin/cat <<EOM >>${logfile}
${date_start} - [Start] - Restic Backup
EOM

# Backups
for index in ${!backups[*]}; do
  time_start=$(date +%s)

  echo crestic ${backups[$index]} backup

  time_diff=$(($(date +%s) - time_start))

  # Log
  echo "$((time_diff / 60)) min $((time_diff % 60)) sec - ${backups[$index]}" >>${logfile}
done

# Call forget/prune
time_start=$(date +%s)

./cr_forget.sh

time_diff=$(($(date +%s) - time_start))

full_min=$((SECONDS / 60))
mod_sec=$((SECONDS % 60))

# Log
echo "$((time_diff / 60)) min $((time_diff % 60)) sec - Forget" >>${logfile}
echo "${full_min} min ${mod_sec} sec - Total" >>${logfile}

# output for console or cronjob mail
# echo "${full_min} min ${mod_sec} sec - Backup"

# EOF