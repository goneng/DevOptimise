# Set Default Date-Format on macOS Terminal <!-- omit in toc -->

**Table of Contents**
- [1. Identify the Default Shell of your Account](#1-identify-the-default-shell-of-your-account)
- [2. Set the Default Locale for Terminal](#2-set-the-default-locale-for-terminal)
  - [For Bash (default shell in macOS Mojave and earlier)](#for-bash-default-shell-in-macos-mojave-and-earlier)
  - [For Zsh (default shell in macOS Catalina and later)](#for-zsh-default-shell-in-macos-catalina-and-later)
- [3. Restart Terminal](#3-restart-terminal)
- [4. Verify Changes](#4-verify-changes)
  - [Example Output](#example-output)

&nbsp;

To change the default date format in your Mac Terminal to English, \
you can adjust the locale settings. \
(good for setting `ls -l` results and such)

Here's a step-by-step guide:

## 1. Identify the Default Shell of your Account

1. Open the Terminal.
2. Run the following command to identify your default shell:
    ```sh
    dscl . -read ~/ UserShell
    ```
3. Should get one of the following results:
   - `UserShell: /bin/bash` \
      means your default shell is **Bash**
   - `UserShell: /bin/zsh` \
      means your default shell is **Zsh**

## 2. Set the Default Locale for Terminal

You can set the default locale specifically for the Terminal app \
by modifying the `.zshrc` or `.bash_profile` file, \
depending on the shell you are using.

### For Bash (default shell in macOS Mojave and earlier)

1. Open the Terminal.
2. Open the `.bash_profile` file in a text editor:
    ```sh
    nano ~/.bash_profile
    ```
3. Add the following lines to set the locale to U.S.-English:
    ```sh
    # Set the default locale to US-English
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    ```
4. Save the file and exit the text editor (`control`+`X`, then `Y` to confirm).
5. Apply the changes by sourcing the `.bash_profile` file: \
   (this will apply the change in the current session, so you could confirm it right away)
    ```sh
    source ~/.bash_profile
    ```

### For Zsh (default shell in macOS Catalina and later)

1. Open the Terminal.
2. Open the `.zshrc` file in a text editor:
    ```sh
    nano ~/.zshrc
    ```
3. Add the following lines to set the locale to U.S.-English:
    ```sh
    # Set the default locale to US-English
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    ```
4. Save the file and exit the text editor (`control`+`X`, then `Y` to confirm).
5. Apply the changes by sourcing the `.zshrc` file: \
   (this will apply the change in the current session, so you could confirm it right away)
    ```sh
    source ~/.zshrc
    ```

## 3. Restart Terminal

After making these changes, restart your Terminal to ensure the new settings take effect. \
Open a new Terminal window and check the date format.

## 4. Verify Changes

To verify that the changes have taken effect, you can run:

```sh
locale
```
This command should display the locale settings, \
showing `en_US.UTF-8` for relevant locale variables.

### Example Output

After making the changes, the date should now display in English when you run the date command:

```sh
date
```

This should show the date in the format, for example:

```sh
Tue May 22 14:45:00 PDT 2024
```

These steps will ensure your Terminal displays dates in *English* by default.

&nbsp;
