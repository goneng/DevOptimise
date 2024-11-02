#!/bin/bash -e

# Set default values for parameters, case they are empty or undefined
: "${GIT_ROOT:=$(git rev-parse --show-toplevel)}"
: "${SCRIPT_HOME:=$GIT_ROOT/Azure_DevOps/}"
: "${ACTION:=list}"

SCRIPT_NAME="$(basename "$0")"
echo "--- -----------------------------------------------------------------------------------------"
echo "-S- ${SCRIPT_NAME}: List Azure-DevOps Users (in ${ADO_ORG})"
echo "--- -----------------------------------------------------------------------------------------"
echo "-I- Running as '$(whoami)' on '$(hostname)'"

source "${GIT_ROOT}/Unix_Admin/bin/devops_fun.sh"

# -------------------------------------------------------------------------------------- #

if [[ -z "${ADO_PAT}" ]]
then
  export ADO_PAT=$(do_fun_get_token_from_env ADO_PAT_READ)
fi
do_fun_validate_param_silent ADO_PAT

do_fun_validate_param  ADO_ORG
do_fun_validate_param  ACTION

if [[ ${VERBOSE:-false} != "false" ]]
then
  do_func_show_env_vars
  do_func_show_command_version  python
  do_func_show_command_version  python3

  # Activate command-echo
  set -x
fi

cd "${SCRIPT_HOME}"

# Prepare/use the Virtual-Env ______________________________
VENV_DIR="${SCRIPT_NAME%.*}_venv"  # Strip the extension from the (short) filename

VENV_COMMAND=virtualenv

do_fun_confirm_we_have_python3_package "${VENV_COMMAND}"

do_fun_reset_virtualenv_dir "${VENV_DIR}" "${RESET_VENV}"

# Create the Virtual-Env (force python3)
virtualenv -p "$(which python3)" "${VENV_DIR}"

# Initialize the Virtual-Env
source "${VENV_DIR}/bin/activate"

# Install Required Python Packages on the Virtual-Env
pip3 install -r "${VENV_DIR}_requirements.txt"

do_func_show_python3_packages

# Strip the extension from the (short) filename to get the Python script name
SCRIPT_NAME_PY="${SCRIPT_NAME%.*}.py"

python3 ./"${SCRIPT_NAME_PY}" \
    --ado_org       "${ADO_ORG}" \
    --ado_pat       "${ADO_PAT}" \
    --action        "${ACTION}" \
    ${DRY_RUN} \
    ${VERBOSE} \
    "$@"  # Pass any command-line parameters
