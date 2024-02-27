# git Workflows - Cheat-Sheet <!-- omit in toc -->

- [Check Impact-of-Change](#check-impact-of-change)
- [Count Lines-of-Code](#count-lines-of-code)
  - [Using Git and Unix Commands](#using-git-and-unix-commands)
  - [Using the CLOC script](#using-the-cloc-script)

Covers two common workflows for git -

- Multiple commits per branch (the "classic" workflow)
- A Single Commit per branch (with `amend` and `push-force`)

See also

- [How to add aliases to your working-environment](./source_git_aliases.sh)
- [The full workflow](./git_Workflows.md)

## Common Steps

| Step | [Aliases](./source_git_aliases.sh) or other Tools | Command in Terminal or Git-Bash | Comments |
| :---        | :--- | :--- | :--- |
| (Clone the Repo.)	 |  | `git clone <URL_FROM_GITLAB>`       |  |
| Create New Branch<br>and Switch to it |  | `git fetch (--prune)`<br>`git switch -c <NEW_BRANCH> origin/<BASE_BRANCH>` | To create the branch via GitLab UI,<br>see [the full Workflow](./git_Workflows.md) |







Create Initial Commit

Use a Git-Client

(don't use the IDE)


    git status
    git diff
    git add <FILE>
    git commit -m "<COMMIT_MESSAGE>"



DO NOT USE:

    git add *
    git add .

(I will slap you)
Push Initial Commit
to Remote Branch





    git push

OR:

    git push -u origin <NEW_BRANCH>





## Specific Steps

### Multi-Commit Workflow

### Single-Commit Workflow

## Other Related Actions

| Syntax      | Description | Test Text     |
| :---        |    :----:   |          ---: |
| Header      | Title       | Here's this   |
| Paragraph   | Text        | And more      |