
# Fix MS-Teams stuck on macOS <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->
- [Clean MS-Teams Cache](#clean-ms-teams-cache)

&nbsp;

## Clean MS-Teams Cache

Based on [Glorfindel](https://apple.stackexchange.com/users/121968/glorfindel)'s answer to the SO question
[How to delete cache of Microsoft Teams on macOS](https://apple.stackexchange.com/a/407428/28372)

- Close MS-Teams
- Open Terminal
- Run the script [fix_ms_teams_macos.sh](bin/fix_ms_teams_macos.sh) to clean MS-Teams cache and restore behavior:
    ```bash
    Unix_Admin/bin/fix_ms_teams_macos.sh
    ```

&nbsp;
