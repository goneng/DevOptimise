# git Tips <!-- omit in toc -->

### Table of Contents <!-- omit in toc -->
- [Check Impact-of-Change](#check-impact-of-change)
- [Count Lines-of-Code](#count-lines-of-code)
  - [Using the CLOC Tool](#using-the-cloc-tool)
  - [Using Git and Unix Commands](#using-git-and-unix-commands)
- [Find Commits that Introduced a Change](#find-commits-that-introduced-a-change)
- [Find Large Files in a Repository](#find-large-files-in-a-repository)
  - [Find Files Larger than 1MB (1000000 bytes)](#find-files-larger-than-1mb-1000000-bytes)
  - [Find the 7 Largest Files in a Repository](#find-the-7-largest-files-in-a-repository)
  - [Find the Commit that Added a (Large) File](#find-the-commit-that-added-a-large-file)
- [Get Commit-Statistics](#get-commit-statistics)
  - [Get Commit-Count by Author](#get-commit-count-by-author)
- [Rename the Default Branch from 'master' to 'main'](#rename-the-default-branch-from-master-to-main)

&nbsp;

## Check Impact-of-Change

See how many files (and lines) have changed, between two commits

```bash
git diff --shortstat <commit1> <commit2>
```

(from [How can I calculate the number of lines changed between two commits in git](https://stackoverflow.com/a/2528129/1390251))

&nbsp;

## Count Lines-of-Code

### Using the CLOC Tool

[**CLOC** (Count Lines Of Code)](https://github.com/AlDanial/cloc) is a Perl-script that does just that.

You can also install it as a package from your Linux-distribution (which is great) \
or run it as a docker-container (which is an overkill in most cases).

Run it in a Git-repo, like so:

```bash
cloc --vcs git
# or
cloc --git .
```

### Using Git and Unix Commands

Count ALL lines-of-code in a repository (limited to a selected set of file-types) -

```bash
git ls-files | grep -P "^[^\s]+[.](c|cpp|h|hpp|java|js)$" | xargs cat | wc -l
```

This example does not handle file-names with spaces, so skipping these files.

(from [Count number of lines in a git repository](http://stackoverflow.com/questions/4822471/count-number-of-lines-in-a-git-repository))

&nbsp;

## Find Commits that Introduced a Change

```bash
# Find commits with a specific RegEx
git log -G '<regex-to-find>'

# ... ignore-case
git log -i -G '<regex-to-find>'

# ... in all branches
git log --all -G '<regex-to-find>'
```

&nbsp;

## Find Large Files in a Repository

### Find Files Larger than 1MB (1000000 bytes)

```bash
export SIZE_IN_BYTES=1000000;
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | grep -v -e 'tag' | awk '$3 > ENVIRON["SIZE_IN_BYTES"]' | sort --numeric-sort --key=3
```

### Find the 7 Largest Files in a Repository

```bash
export FILE_COUNT=7;
git rev-list --objects --all |
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
  sed -n 's/^blob //p' |
  sort --human-numeric-sort --reverse --key=2 |
  cut -c 1-12,41- |
  $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest | head -n $FILE_COUNT
```

(from [How to find/identify large commits in git history?](https://stackoverflow.com/a/42544963/1390251))

### Find the Commit that Added a (Large) File

```bash
git log --raw --all --find-object=<BLOB_ID>
```
(from [Which commit has this blob?](https://stackoverflow.com/a/66662476/1390251))

## Get Commit-Statistics

### Get Commit-Count by Author

```bash
git shortlog --summary --numbered --all
# or
git shortlog --summary --numbered --all --no-merges
# or
git shortlog --summary --numbered --all --no-merges --email
```

(from [Git number of commits per author on all branches](https://stackoverflow.com/a/9839491/1390251))

&nbsp;

## Rename the Default Branch from 'master' to 'main'

1. Change the name of the default branch via the UI of GitLab/GitHub
2. Run the following commands on your local copy of that repo:
    ```bash
    git branch -m master main
    git fetch origin
    git branch -u origin/main main
    git remote set-head origin -a
    # Optional:
    git fetch --prune
    ```
&nbsp;

