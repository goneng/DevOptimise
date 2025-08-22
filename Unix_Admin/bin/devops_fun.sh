#!/bin/bash

# Utilities to include in bash-scrips__________________________________________

function do_fun_trace() {
  MSG=$1
  { echo "$MSG"; } 2> /dev/null
}

function do_fun_trace_dbg() {
  MSG=$1
  { do_fun_trace "-D- $MSG"; } 2> /dev/null
}

function do_fun_trace_err() {
  MSG=$1
  { do_fun_trace "-E- $MSG"; } 2> /dev/null
}

function do_fun_trace_inf() {
  MSG=$1
  { do_fun_trace "-I- $MSG"; } 2> /dev/null
}

function do_fun_trace_wrn() {
  MSG=$1
  { do_fun_trace "-W- $MSG"; } 2> /dev/null
}

# --------------------------------------------------------------------------- #

function do_fun_validate_param() {
  PARAM_NAME=$1

  if [[ -z ${!PARAM_NAME} ]]
  then
    { do_fun_trace_err "${PARAM_NAME} is not defined - Exiting"; } 2> /dev/null
    exit 8
  else
    { do_fun_trace_dbg "${PARAM_NAME}: '${!PARAM_NAME}'"; } 2> /dev/null
  fi
}

function do_fun_validate_param_silent() {
  PARAM_NAME=$1

  if [[ -z ${!PARAM_NAME} ]]
  then
    { do_fun_trace_err "${PARAM_NAME} is not defined - Exiting"; } 2> /dev/null
    exit 8
  fi
}

# --------------------------------------------------------------------------- #

function do_fun_get_token_from_env() {
  TOKEN_NAME=$1
  TOKEN_VALUE=${!TOKEN_NAME}

  if [[ -z ${TOKEN_VALUE} ]]
  then
    echo "${TOKEN_NAME}_not_set"
  else
    echo "${TOKEN_VALUE}"
  fi
}

# --------------------------------------------------------------------------- #

function do_fun_confirm_we_have_command_from_package() {
  COMMAND=$1
  PACKAGE=$2
  if ! command -v "$COMMAND" &> /dev/null
  then
    { do_fun_trace_wrn "'$COMMAND' could not be found -"; } 2> /dev/null
    { do_fun_trace_wrn "'$COMMAND' should be pre-installed as root."; } 2> /dev/null
    { do_fun_trace_inf "Let's give it a try:"; } 2> /dev/null
    sudo apt install -y "$PACKAGE"
  fi
}

function do_fun_confirm_we_have_column() {
  do_fun_confirm_we_have_command_from_package /usr/bin/column bsdmainutils
}

function do_fun_confirm_we_have_jq() {
  do_fun_confirm_we_have_command_from_package /usr/bin/jq jq
}

function do_fun_confirm_we_have_python3_package() {
  PIP_PACKAGE=$1

  if ! command -v "$PIP_PACKAGE" &> /dev/null
  then
    { do_fun_trace_wrn "pip3 package '$PIP_PACKAGE' could not be found -"; } 2> /dev/null
    { do_fun_trace_wrn "pip3 package '$PIP_PACKAGE' should be pre-installed as root."; } 2> /dev/null
    { do_fun_trace_inf "Let's give it a try:"; } 2> /dev/null
    sudo pip3 install "$PIP_PACKAGE"
  fi
}

function do_fun_reset_virtualenv_dir() {
  VENV_DIR=$1
  RESET_VENV=$2
  : "${VENV_DIR:=MISSING_DIR_NAME}"    # Set default value

  if [[ ${RESET_VENV:-false} != "false" ]]
  then
    { do_fun_trace_inf "RESETTING VENV '${VENV_DIR}'..."; } 2> /dev/null
    if [[ ${VENV_DIR} == "/" ]]
    then
      { do_fun_trace_err "Trying to delete '/' - Exiting"; } 2> /dev/null
      exit 8
    fi
    if [[ ${VENV_DIR} == "." ]]
    then
      { do_fun_trace_err "Trying to delete '.' - Exiting"; } 2> /dev/null
      exit 8
    fi
    if [[ ${VENV_DIR} == *..* ]]
    then
      { do_fun_trace_err "Trying to delete '..' - Exiting"; } 2> /dev/null
      exit 8
    fi
    if [[ -d "${VENV_DIR}" ]]
    then
      rm -Rf "${VENV_DIR}"
      { do_fun_trace_inf "RESETTING VENV '${VENV_DIR}' - Done"; } 2> /dev/null
    else
      { do_fun_trace_dbg "VENV Dir not found: '${VENV_DIR}' - skipping"; } 2> /dev/null
    fi
  fi
}

function do_func_show_command_version() {
  COMMAND=$1
  VERSION_FLAG=$2
  : "${VERSION_FLAG:=--version}"    # Set default value

  { do_fun_trace "${COMMAND} ${VERSION_FLAG}: _________________________________________________________"; } 2> /dev/null
  if command -v "${COMMAND}" &> /dev/null
  then
    "${COMMAND}" ${VERSION_FLAG}
  else
    { do_fun_trace_wrn "Command '${COMMAND}' not found"; } 2> /dev/null
  fi
  { do_fun_trace ""; } 2> /dev/null
}

function do_func_show_env_vars() {
  { do_fun_trace ""; } 2> /dev/null
  { do_fun_trace "ENV: ____________________________________________________________________"; } 2> /dev/null
  env | sort
  { do_fun_trace "_________________________________________________________________________"; } 2> /dev/null
  { do_fun_trace ""; } 2> /dev/null
}

function do_func_show_python3_packages() {
  { do_fun_trace "Python3 Packages: _______________________________________________________"; } 2> /dev/null
  pip3 freeze
  { do_fun_trace "_________________________________________________________________________"; } 2> /dev/null
  { do_fun_trace ""; } 2> /dev/null
}

# --------------------------------------------------------------------------- #
