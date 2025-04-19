#!/bin/zsh
# ____________________________________________________________________________
# The Best ZshRC file, EVER

# Force locale en_US.UTF-8 ____________________________________________________
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# If not running interactively, don't do anything ____________________________
case $- in
  *i*) ;;
  *) return;;
esac

echo "running my .zshrc ($0)"

# Enable color support of ls and also add handy aliases ______________________
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Load Aliases _______________________________________________________________
MY_ALIASES_FILE=~/.zsh/aliases.sh
if [[ -f ${MY_ALIASES_FILE} ]]
then
  echo "Sourcing '${MY_ALIASES_FILE}' ..."
  source ${MY_ALIASES_FILE}
else
  echo "(no '${MY_ALIASES_FILE}' file - skipping)"
fi

# Load git-prompt script (assumes Interactive shell) _________________________
MY_GIT_PROMPT_FILE=~/.zsh/git-prompt.sh
if [ -f ${MY_GIT_PROMPT_FILE} ]
then
  echo "Sourcing '${MY_GIT_PROMPT_FILE}' ..."
  source ${MY_GIT_PROMPT_FILE}        # Show git branch name at command prompt
  export GIT_PS1_SHOWCOLORHINTS=true  # Option for git-prompt.sh to show branch name in color

  # Set some more options
  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWUPSTREAM="auto"

  setopt PROMPT_SUBST # Sets parameter-expansion, command-substitution and arithmetic-expansion to be performed in prompts
  # Append to the existing shell:
  # PS1+='$(__git_ps1 " (%s)") %# '
  # ...or replace the existing shell:
  # PS1='%n@%m %1~ $(__git_ps1 "[%s]") %# '
    PS1='%n@%m %c$(__git_ps1 " (%s)") %# '
else
  echo "(no '${MY_GIT_PROMPT_FILE}' file - skipping)"
fi

# Load Git Completion ________________________________________________________
#  - see https://www.oliverspryn.com/blog/adding-git-completion-to-zsh
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit

# Load KubeCTL Completion ____________________________________________________
#  - see https://komodor.com/learn/kubectl-autocomplete-enabling-and-using-in-bash-zsh-and-powershell/
if command -v kubectl &> /dev/null
then
  MY_KUBECTL_COMPLETION_FILE=~/.zsh/kubectl-completion.zsh
  (kubectl completion zsh) > ${MY_KUBECTL_COMPLETION_FILE}
  if [[ -f ${MY_KUBECTL_COMPLETION_FILE} ]]
  then
    echo "Sourcing '${MY_KUBECTL_COMPLETION_FILE}' ..."
    source ${MY_KUBECTL_COMPLETION_FILE}
  else
    echo "(no '${MY_KUBECTL_COMPLETION_FILE}' file - skipping)"
  fi
else
  echo "(kubectl not found, skipping completion setup)"
fi
