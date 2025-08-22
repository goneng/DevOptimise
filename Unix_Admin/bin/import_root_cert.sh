#!/bin/bash -e
# (run with 'exit-on-error')

# Based on Thomas Leister's post -
# See https://thomas-leister.de/en/how-to-import-ca-root-certificate/
### Script installs root.cert.cer to certificate trust store of applications using NSS
### (e.g. Firefox, Thunderbird, Chromium)
### Mozilla uses cert8, Chromium and Chrome use cert9

SCRIPT_NAME=$(basename "$0")
echo "--- -----------------------------------------------------------------------------------------"
echo "-S- ${SCRIPT_NAME}: Import Root-Certificate to this Host"
echo "--- -----------------------------------------------------------------------------------------"

CERT_FILE=$1
CERT_NAME=$2

# Set default values for parameters, case they are empty or undefined
: "${CERT_FILE:=${HOME}/root.cert.cer}"
: "${CERT_DEST:=/usr/local/share/ca-certificates/extra}"
: "${CERT_NAME:=Some Root CA}"
# : "${VERBOSE:=false}"

# FUNCTIONS ----------------------------------------------------------------------------------------

function add_cert {
  cert_db_type=$1
  cert_db_path=$2
  cert_dest=$3
  cert_name=$4
  cert_dir=$(dirname "${cert_db_path}")

  echo "-I- Adding certificate '${cert_dest}'"
  echo "                    as '${cert_name}'"
  sudo certutil -A -n "${cert_name}" -t "TCu,Cu,Tu" -i "${cert_dest}" -d "${cert_db_type}":"${cert_dir}"
  echo
}

function list_certs {
  cert_db_type=$1
  cert_db_path=$2
  cert_dir=$(dirname "${cert_db_path}")
  cert_connection=${cert_db_type}:${cert_dir}

  echo "-I- Existing ${cert_db_type} Certificates in ${cert_db_path}__________________________________________"
  echo "-D- (${cert_connection})"
  certutil -d "${cert_connection}" -L
  echo
}

function usage_msg {
  message_text=$1
  echo
  echo "${message_text}"
  echo
  echo "-I- Usage:"
  echo "-I-   ${SCRIPT_NAME}  [cert-file] [cert-name]"
  echo
}

# MAIN ---------------------------------------------------------------------------------------------

if [[ -f $CERT_FILE ]]
then
  echo "-I-"
  echo "-I- Importing Certificate-file \"$CERT_FILE\"..."
else
  usage_msg "-E- Certificate-file Not Found - \"$CERT_FILE\" - Exiting"
  exit 8
fi

if [[ ${VERBOSE:-false} != "false" ]]
then
  echo "-- ENV ------------------------------------------------------------------"
  env | sort
  echo "-- ENV ------------------------------------------------------------------"

  # Activate command-echo
  set -x
fi

# Check for Prerequisites
if [[ -d ${CERT_DEST} ]]
then
  echo "-I-"
  echo "-I- Found the folder for \"extra\" certificates (${CERT_DEST})"
  echo "    - assume we are all set"
else
  echo "-I- Creating a folder for our \"Extra\" certificates (${CERT_DEST})"
  sudo mkdir -p "${CERT_DEST}"

  #FIXME: Have a separate test for this
  echo "-I- Making sure we have the \"Network Security Service tools\""
  sudo apt install libnss3-tools
fi

# Avoid having two certificates with the same name, i.e.: ensure uniqueness
# (see https://punkwalrus.livejournal.com/1198022.html )
CURR_TIME=$(date +%Y-%m-%d_%H-%M)
CERT_NAME="${CERT_NAME} (${CURR_TIME})"
CERT_FILE_BASE=$(basename "$CERT_FILE")
CERT_FILE_DEST=${CERT_DEST}/${CERT_FILE_BASE}

echo "-I- Copying the certificate '${CERT_FILE}'"
echo "-I-                      to '${CERT_DEST}'"
sudo cp "${CERT_FILE}" "${CERT_DEST}/"
echo

### For cert8 (legacy - DBM)
find "${HOME}"/ -name 'cert8.db' |
while read CERT_DB
do
  list_certs dbm "${CERT_DB}"
  add_cert   dbm "${CERT_DB}" "${CERT_FILE_DEST}" "${CERT_NAME}"
done

### For cert9 (SQL)
find "${HOME}"/ -name 'cert9.db' |
while read CERT_DB
do
  list_certs sql "${CERT_DB}"
  add_cert   sql "${CERT_DB}" "${CERT_FILE_DEST}" "${CERT_NAME}"
done

echo
echo "-I- To DELETE any certificate, run:"
echo "    certutil -d [dbm|sql]:<cert-dir> -D -n '<certificate nickname>'"
echo

exit 0
