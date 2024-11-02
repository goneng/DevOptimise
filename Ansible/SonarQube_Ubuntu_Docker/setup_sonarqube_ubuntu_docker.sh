#!/usr/bin/env bash

# Set default values for parameters, case they are empty or undefined
: "${GIT_ROOT:=$(git rev-parse --show-toplevel)}"
: "${SCRIPT_HOME:=$GIT_ROOT/Ansible/SonarQube_Ubuntu_Docker/}"

SCRIPT_NAME="$(basename "$0")"
echo "--- -----------------------------------------------------------------------------------------"
echo "-S- ${SCRIPT_NAME}: Setup SonarQube on Ubuntu using Docker"
echo "--- -----------------------------------------------------------------------------------------"
echo "-I- Running as '$(whoami)' on '$(hostname)'"

source "${GIT_ROOT}/Unix_Admin/bin/devops_fun.sh"

# -------------------------------------------------------------------------------------- #

do_fun_validate_param        ANSIBLE_USER
do_fun_validate_param_silent ANSIBLE_PASS

if [[ ${VERBOSE:-false} != "false" ]]
then
  do_func_show_env_vars
  do_func_show_command_version  python
  do_func_show_command_version  python3

  # Activate command-echo
  set -x
fi

cd "${SCRIPT_HOME}" || exit

# Prepare/use the Virtual-Env ______________________________
VENV_DIR="${SCRIPT_NAME%.*}_venv"  # Strip the extension from the (short) filename

VENV_COMMAND=virtualenv

do_fun_confirm_we_have_python3_package "${VENV_COMMAND}"

do_fun_reset_virtualenv_dir "${VENV_DIR}" "${RESET_VENV}"

# Create the Virtual-Env (force python3)
virtualenv -p "$(which python3)" "${VENV_DIR}"

# Initialize the Virtual-Env
source "${VENV_DIR}/bin/activate"

export ANSIBLE_COLLECTIONS_PATH="${VENV_DIR}/collections"
ansible-galaxy collection install community.docker
ansible-galaxy collection list

ansible-playbook -i inventory_sonarqube.yml setup_sonarqube_ubuntu_docker.yml \
    --extra-vars "ANSIBLE_USER=${ANSIBLE_USER}" \
    --extra-vars "ANSIBLE_PASS=${ANSIBLE_PASS}" \
    ${VERBOSE} \
    "$@"

# -------------------------------------------------------------------------------------- #
echo "-D- ${SCRIPT_NAME}: Done."
