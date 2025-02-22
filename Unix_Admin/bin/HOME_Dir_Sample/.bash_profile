
if [[ -x /opt/homebrew/bin/brew ]]
then    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    if [[ -x /usr/local/bin/brew ]]
    then    # Mac-Intel
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi
