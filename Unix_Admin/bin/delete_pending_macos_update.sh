#!/bin/bash -e
# (run with 'exit-on-error')

SCRIPT_NAME=$(basename "$0")
echo "--- -----------------------------------------------------------------------------------------"
echo "-S- ${SCRIPT_NAME}: Identify and delete pending macOS upgrades"
echo "--- -----------------------------------------------------------------------------------------"

# Set default values for parameters, case they are empty or undefined
: "${UPDATE_ASSETS_FLDR:=/System/Library/AssetsV2/com_apple_MobileAsset_MacSoftwareUpdate}"
: "${VERBOSE:=false}"
DELETE_MODE=false

# Parse command line arguments
for arg in "$@"
do
  case "${arg}" in
    --delete)
      DELETE_MODE=true
      ;;
    --verbose)
      VERBOSE=true
      ;;
    --help|-h)
      echo "Usage: ${SCRIPT_NAME} [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --delete   Actually delete the pending update assets (requires sudo)"
      echo "  --verbose  Show detailed output"
      echo "  --help     Show this help message"
      echo ""
      echo "Without --delete, the script only checks for pending updates."
      exit 0
      ;;
    *)
      echo "-E- Unknown option: ${arg}"
      echo "-I- Use --help for usage information"
      exit 1
      ;;
  esac
done

# MAIN ---------------------------------------------------------------------------------------------

echo "-I- Checking for pending macOS updates via APFS snapshots..."

# Check for pending updates by looking at APFS snapshots
SNAPSHOT_OUTPUT=$(diskutil apfs listSnapshots / 2>&1) || true

if [[ "${VERBOSE}" == "true" ]]
then
  echo "-D- Snapshot output:"
  echo "${SNAPSHOT_OUTPUT}"
fi

if echo "${SNAPSHOT_OUTPUT}" | grep -q "com.apple.os.update"
then
  PENDING_UPDATE=$(echo "${SNAPSHOT_OUTPUT}" | grep "com.apple.os.update")
  echo "-I- Found pending macOS update snapshot:"
  echo ">>> ${PENDING_UPDATE}"

  if [[ "${DELETE_MODE}" == "true" ]]
  then
    echo "-I- Attempting to delete update assets from: ${UPDATE_ASSETS_FLDR}"

    # Safety check: ensure UPDATE_ASSETS_FLDR is not empty and is the expected path
    if [[ -z "${UPDATE_ASSETS_FLDR}" ]]
    then
      echo "-E- UPDATE_ASSETS_FLDR is empty - refusing to delete. Exiting."
      exit 2
    fi

    if [[ -d "${UPDATE_ASSETS_FLDR}" ]]
    then
      # Note: This operation requires root privileges
      if [[ ${EUID} -ne 0 ]]
      then
        echo "-W- This script requires root privileges to delete update assets"
        echo "-I- Re-run with: sudo ${SCRIPT_NAME} --delete"
        exit 1
      fi

      echo ""
      echo "-I- Deleting the content of the update folder"
      echo "   '${UPDATE_ASSETS_FLDR}'"
      echo ""
      echo "-I- Because I don't trust myself, please consider running this command as root,"
      echo "    to delete that folder:"
      echo "    'rm -rf "${UPDATE_ASSETS_FLDR:?}"/*'"
      # echo "-I- Successfully deleted pending update assets"
    else
      echo "-W- Update assets folder not found - skipping"
      echo "    (${UPDATE_ASSETS_FLDR})"
    fi
  else
    echo ""
    echo "-I- To delete the pending update, re-run with: sudo ${SCRIPT_NAME} --delete"
    echo ""
  fi
else
  echo "-I- No pending macOS update found - all is good"
fi

exit 0
