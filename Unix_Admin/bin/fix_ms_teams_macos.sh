#!/bin/bash -e
# (run with 'exit-on-error')

SCRIPT_NAME=$(basename $0)
echo "--- -----------------------------------------------------------------------------------------"
echo "-S- ${SCRIPT_NAME}: Clean MS-Teams cache on MacOS"
echo "--- -----------------------------------------------------------------------------------------"
echo "Based on [Glorfindel](https://apple.stackexchange.com/users/121968/glorfindel)'s post -"
echo "See https://apple.stackexchange.com/a/407428/28372"

# Set default values for parameters, case they are empty or undefined
: "${CACHE_FLDR:=${HOME}/Library/Caches/com.microsoft.teams}"
: "${APPSUP_FLDR:=${HOME}/Library/Application Support/Microsoft/Teams}"
# : "${VERBOSE:=false}"

# MAIN ---------------------------------------------------------------------------------------------

if [[ -d ${CACHE_FLDR} ]]
then
  rm -rf "${CACHE_FLDR}"
else
  echo "-W- Failed to find MS-Teams cache-folder - skipping"
  echo "    (${CACHE_FLDR})"
fi

if [[ -d ${APPSUP_FLDR} ]]
then
  rm "${APPSUP_FLDR}/desktop-config.json"
  rm "${APPSUP_FLDR}/storage.json"
  rm "${APPSUP_FLDR}/Network Persistent State"

  rm -rf "${APPSUP_FLDR}"/*Cache*
  rm -rf "${APPSUP_FLDR}/blob_storage"
  rm -rf "${APPSUP_FLDR}/databases"
  rm -rf "${APPSUP_FLDR}/IndexedDB"
  rm -rf "${APPSUP_FLDR}/Local Storage"
  rm -rf "${APPSUP_FLDR}/tmp"
else
  echo "-W- Failed to find MS-Teams Application-Support folder - skipping"
  echo "    (${APPSUP_FLDR})"
fi

exit 0
