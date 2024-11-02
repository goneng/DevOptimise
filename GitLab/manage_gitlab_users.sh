#!/bin/bash -e

# Set default values for parameters, case they are empty or undefined
: "${GIT_ROOT:=$(git rev-parse --show-toplevel)}"
: "${SCRIPT_HOME:=$GIT_ROOT/GitLab/}"
: "${SERVER:=gitlab-test}"

SCRIPT_NAME="$(basename "$0")"
echo "--- -----------------------------------------------------------------------------------------"
echo "-S- ${SCRIPT_NAME}: Manage GitLab Users (in ${SERVER})"
echo "--- -----------------------------------------------------------------------------------------"
echo "-I- Running as '$(whoami)' on '$(hostname)'"

source "$(dirname "$0")/../devops_fun.sh"

# -------------------------------------------------------------------------------------- #

if [[ -z "${GITLAB_TOKEN}" ]]
then
  export GITLAB_TOKEN="$(${GIT_ROOT}/GitLab/get_gitlab_token.sh ${SERVER})"
fi
do_fun_validate_param_silent GITLAB_TOKEN

do_fun_validate_param  SERVER
do_fun_validate_param  ACTION

if [[ ${VERBOSE:-false} != "false" ]]
then
  do_func_show_env_vars
  do_func_show_command_version  python
  do_func_show_command_version  python3

  # Activate command-echo
  set -x
fi

cd $SCRIPT_HOME

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

python3 ./manage_gitlab_users.py \
    --server        "${SERVER}" \
    --token         "${GITLAB_TOKEN}" \
    --action        "${ACTION}" \
    ${DRY_RUN} \
    ${VERBOSE} \
    "$@"  # Pass any command-line parameters
