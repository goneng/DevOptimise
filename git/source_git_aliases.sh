#!/usr/bin/env bash

# List existing git-aliases
git config --global alias.alias   '! git config --get-regexp ^alias\. | sort'
git config --global alias.aliases '! git config --get-regexp ^alias\. | sort'

# Shortcuts to common git-actions
git config --global alias.co      checkout
git config --global alias.cp      cherry-pick
git config --global alias.last    'log -1 HEAD'
git config --global alias.shame   'blame -w -M'
git config --global alias.st      'status --short'
git config --global alias.sw      switch
git config --global alias.unstage 'reset HEAD --'

# Show git-history, as graph (like a textual gitk)
git config --global alias.lg  'log --decorate --oneline --graph'
git config --global alias.lga 'log --decorate --oneline --graph --all'

# ...or, if you have x-server support - simply use gitk
git config --global alias.visual '!gitk'

# Rebase your branch
git config --global alias.pr          'pull --rebase'
git config --global alias.pull-rebase 'pull --rebase'

# Rebase your branch - over another branch
git config --global alias.ro          'pull --rebase origin'
git config --global alias.pro         'pull --rebase origin'
git config --global alias.rebase-over 'pull --rebase origin'
git config --global alias.rebase-orig 'pull --rebase origin'

# Force-Push your branch (if applicable)
git config --global alias.push-force  '!git push --force-with-lease origin "$(git rev-parse --abbrev-ref HEAD)"'
git config --global alias.force-push  '!git push --force-with-lease origin "$(git rev-parse --abbrev-ref HEAD)"'

# Git-Gui Tool: Rebase your branch
git config --global "guitool. Pull-Rebase.cmd"          'git pull --rebase'

# Git-Gui Tool: Rebase your branch - over another branch
git config --global "guitool. Pull-Rebase-Over.cmd"     'git pull --rebase origin $REVISION'
git config --global "guitool. Pull-Rebase-Over.revprompt" yes

# Git-Gui Tool: Force-Push your branch (if applicable)
git config --global "guitool. Push-Force.cmd"           'git push --force-with-lease origin $REVISION'
git config --global "guitool. Push-Force.revprompt" yes

# Git-Gui Tool: Cherry-Pick
git config --global "guitool.Cherry-Pick/Continue.cmd"  'git cherry-pick --continue'
git config --global "guitool.Cherry-Pick/__Abort__.cmd" 'git cherry-pick --abort'
git config --global "guitool.Cherry-Pick/__Skip__.cmd"  'git cherry-pick --skip'

# Git-Gui Tool: Rebase
git config --global "guitool.Rebase/Continue.cmd"   'git rebase --continue'
git config --global "guitool.Rebase/__Abort__.cmd"  'git rebase --abort'
git config --global "guitool.Rebase/__Skip__.cmd"   'git rebase --skip'

# Git-Gui Tool: Stash
git config --global "guitool.Stash/(Save).cmd"   'git stash save'
git config --global "guitool.Stash/List.cmd"     'git stash list'
git config --global "guitool.Stash/Pop.cmd"      'git stash pop'
git config --global "guitool.Stash/__Drop__.cmd" 'git stash drop'

# Git-Gui Tool: Change-mode to executable
git config --global "guitool.chmod +x.cmd" 'git update-index --chmod +x $FILENAME'
git config --global "guitool.chmod +x.needsfile" yes

# Git-Gui Tool: Change-mode to non-executable
git config --global "guitool.chmod -x.cmd" 'git update-index --chmod -x $FILENAME'
git config --global "guitool.chmod -x.needsfile" yes
