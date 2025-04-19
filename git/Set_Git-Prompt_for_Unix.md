# Set git-prompt for Unix <!-- omit in toc -->

Note this may cause delays when working in large repositories

### Table of Contents <!-- omit in toc -->
- [Identify Your Default Shell](#identify-your-default-shell)
- [Get a Copy of git-prompt](#get-a-copy-of-git-prompt)
- [Configure your Login Script](#configure-your-login-script)
  - [For Bash](#for-bash)
  - [For Zsh](#for-zsh)

&nbsp;

## Identify Your Default Shell

To identify your default shell, run the following command:

```bash
dscl . -read ~/ UserShell
```

Should get one of the following results:

- `UserShell: /bin/bash` \
  means your default shell is **Bash**
- `UserShell: /bin/zsh` \
  means your default shell is **Zsh**

&nbsp;

## Get a Copy of git-prompt

Depending on your shell, run this in a terminal-window:

```bash
# For Bash:
export MY_SHELL_DIR=~/.bash

# For Zsh:
export MY_SHELL_DIR=~/.zsh
```

Now, get the git-prompt script from GitHub:

```bash
mkdir ${MY_SHELL_DIR}
cd ${MY_SHELL_DIR}
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
chmod 755 git-prompt.sh
```

&nbsp;

## Configure your Login Script

### For Bash

Edit `~/.bashrc` and add the following at the end: \
(at the part that only gets executed in interactive shells)

```bash
...

# Support Git Prompt (assumes Interactive shell)
MY_GIT_PROMPT_FILE=~/.bash/git-prompt.sh
if [ -f ${MY_GIT_PROMPT_FILE} ]
then
  # from https://gist.github.com/eliotsykes/47516b877f5a4f7cd52f (git-aware-bash-prompt.md)
  echo "Sourcing '${MY_GIT_PROMPT_FILE}' ..."
  source ${MY_GIT_PROMPT_FILE} # Show git branch name at command prompt
  export GIT_PS1_SHOWCOLORHINTS=true # Option for git-prompt.sh to show branch name in color

  # Set some more options
  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWUPSTREAM="auto"

  # Append to the existing shell
  PS1+="\$(__git_ps1) "
else
  echo "(no '${MY_GIT_PROMPT_FILE}' file - skipping)"
fi
```

See also: [Bash login script example](../Unix_Admin/bin/HOME_Dir_Sample/.bashrc)

### For Zsh

Edit `~/.zshrc` and add the following at the end: \
(at the part that only gets executed in interactive shells)

```bash
# Load git-prompt script (assumes Interactive shell)
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
```

See also: [Zsh login script example](../Unix_Admin/bin/HOME_Dir_Sample/.zshrc)

&nbsp;

---

&nbsp;
