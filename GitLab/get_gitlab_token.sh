#!/bin/bash

GL_SERVER="$1"
GL_TOKEN="$2"

if [ -n "$GL_TOKEN" ]
then
    # We have a (specific) token - let's use it
    echo "${GL_TOKEN}"
else
    if [ -n "$GL_SERVER" ]
    then
        # Get the token by the server name
        GL_SERVER_CLEAN="${GL_SERVER//-/_}"
        TOKEN_VAR="GITLAB_TOKEN_${GL_SERVER_CLEAN}"
        echo "${!TOKEN_VAR}"
    else
        # No server-name given and no (specific) token in env, so nothing to return
        echo ""
    fi
fi
