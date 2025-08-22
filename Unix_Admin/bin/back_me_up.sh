#!/bin/bash -ex

# Get the current date
BACKUP_TIME=$(date +%Y-%m-%d_%H-%M)

# The folder that contains the files that we want to backup
CURRENT_PATH=$(pwd)
SOURCE_PATH=${CURRENT_PATH}
SOURCE_FOLDER=$(basename "${SOURCE_PATH}")

# Create a backup file using the current date in it's name
DESTINATION=${SOURCE_FOLDER}_${BACKUP_TIME}.tar.gz

# Create the backup -
# - with full-path:
#         tar --exclude-backups --exclude-ignore-recursive=back_me_up_EXCLUDE.lst -cpzf ../"${DESTINATION}" "${SOURCE_PATH}"
# - with relative path:
pushd ..; tar --exclude-backups --exclude-ignore-recursive=back_me_up_EXCLUDE.lst -cpzf "${DESTINATION}" "${SOURCE_FOLDER}"
popd

set +x
LIST_RESULTS=$(ls -l ../"${DESTINATION}")
echo "--------------------------------------------------------------------------------------------"
echo "Backup-File created:"
echo "${LIST_RESULTS}"
echo "--------------------------------------------------------------------------------------------"

exit
