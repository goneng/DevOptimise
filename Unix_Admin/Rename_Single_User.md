# Rename User (on single-user Ubuntu machines) <!-- omit in toc -->

On a single-user Linux (like X/Ubuntu)\
this allows you to reassign the machine without reinstalling it.

(base on [Change the Username and Hostname on Ubuntu](https://hepeng.me/changing-username-and-hostname-on-ubuntu/))

### Table of Contents <!-- omit in toc -->
- [Rename User](#rename-user)
  - [Disable Auto-Login](#disable-auto-login)
  - [Unlock the root Account](#unlock-the-root-account)
  - [Optional: Allow SSH-Access to the root Account](#optional-allow-ssh-access-to-the-root-account)
  - [Switch User to root](#switch-user-to-root)
  - [Rename the User](#rename-the-user)
  - [Rename the Group](#rename-the-group)
  - [Optional: Change the User's Password](#optional-change-the-users-password)
  - [Fix Permissions in Home-Dir](#fix-permissions-in-home-dir)
  - [Confirm You can Log-In](#confirm-you-can-log-in)
  - [Optional: Lock the root Account](#optional-lock-the-root-account)
- [Troubleshooting](#troubleshooting)
  - [Error: Configured directory for incoming files does not exist](#error-configured-directory-for-incoming-files-does-not-exist)

## Rename User

### Disable Auto-Login

(so you could log-in as root)

...

### Unlock the root Account

Set a password for your 'root' account -

```bash
sudo -i
...
passwd
... (password)
... (again)
```

### Optional: Allow SSH-Access to the root Account

...

```bash
sudo -i
...
passwd
... (password)
... (again)
```

### Switch User to root

Reboot, and log-in as 'root'

### Rename the User

```bash
usermod -l <newname> -d /home/<newname> -m <oldname>
```

### Rename the Group

(In single-user mode, it is named like the user)

```bash
groupmod -n <newgroup> <oldgroup>
```

### Optional: Change the User's Password

Change the password:

```bash
passwd <newname>
... (new password)
... (again)
```

### Fix Permissions in Home-Dir

(this may get trashed because you've connected as `root`)

```bash
sudo chown -R <newname>:<newname> /home/<newname>
```

### Confirm You can Log-In

Reboot and log-in as your new user

(**if it fails - re-login as `root` and fix whatever went wrong**)

### Optional: Lock the root Account

Re-connect as `root` and run this:

```bash
passwd -l root
```

## Troubleshooting

### Error: Configured directory for incoming files does not exist

- Cause: The `Download` directory had moved
- Resolution:
    Log-in as `root`, then run

    ```bash
    su - <newname>
    sudo blueman-services &
    ```

  - Wait a few seconds for the dialog to pop
  - Choose **Transfer** and set an **Incoming Folder**
- From: https://askubuntu.com/a/874145/138065
