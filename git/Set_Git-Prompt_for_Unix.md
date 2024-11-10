# Set git-prompt for Unix <!-- omit in toc -->

Note this may cause delays when working in large repositories

### Table of Contents <!-- omit in toc -->
- [Get a Copy of git-prompt](#get-a-copy-of-git-prompt)
- [Configure your Login Script](#configure-your-login-script)

&nbsp;

## Get a Copy of git-prompt

Run this in a terminal-window:

```bash
mkdir ~/.bash
cd ~/.bash
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
chmod 755 git-prompt.sh
```

&nbsp;

## Configure your Login Script

Edit `~/.bashrc` and add the following at the end:\
(at the part that only gets executed in interactive shells)

```bash
...

# Support Git Prompt (assumes Interactive shell)
if [ -f ~/.bash/git-prompt.sh ]; then
    # from https://gist.github.com/eliotsykes/47516b877f5a4f7cd52f (git-aware-bash-prompt.md)
    source ~/.bash/git-prompt.sh # Show git branch name at command prompt
    export GIT_PS1_SHOWCOLORHINTS=true # Option for git-prompt.sh to show branch name in color

    # Set some more options
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWUPSTREAM="auto"

    # Append to the existing shell
    PS1+="\$(__git_ps1) "
fi
```

&nbsp;
