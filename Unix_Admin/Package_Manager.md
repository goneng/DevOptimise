# Manage Software Packages <!-- omit in toc -->

Tips for working with package-managers like `apt-get`

### Table of Contents <!-- omit in toc -->
- [A Typical Workflow](#a-typical-workflow)
- [apt / apt-get (Ubuntu, Debian)](#apt--apt-get-ubuntu-debian)
  - [Find the Origin of a File](#find-the-origin-of-a-file)
    - [dpkg search](#dpkg-search)
    - [apt-file find](#apt-file-find)
  - [Install or Upgrade a Package](#install-or-upgrade-a-package)
    - [Install/upgrade the _latest_ revision of a package](#installupgrade-the-latest-revision-of-a-package)
    - [Install/upgrade a _specific_ revision of a package](#installupgrade-a-specific-revision-of-a-package)
  - [List Available Revisions of a Package](#list-available-revisions-of-a-package)
  - [List Packages](#list-packages)
    - [List available packages](#list-available-packages)
    - [List _installed_ packages](#list-installed-packages)
    - [List _upgradable_ packages](#list-upgradable-packages)
  - [Manage Package-Repository Keys](#manage-package-repository-keys)
    - [Add a Missing Key](#add-a-missing-key)
  - [Refresh the List of Available Packages](#refresh-the-list-of-available-packages)

&nbsp;

## A Typical Workflow

- Refresh the list of available packages
- List packages to find the one we need
- List available revisions of a package
- Install or upgrade a package

&nbsp;

## apt / apt-get (Ubuntu, Debian)

&nbsp;

### Find the Origin of a File

Locate the package that a file belongs to\
(see also [ask-ubuntu: How do I find the package that provides a file?](https://askubuntu.com/q/481/138065))

&nbsp;

#### dpkg search

- scans the content of installed packages only

`dpkg -S <full/path/and/filename>`

or

`dpkg --search $(which <command>)`

&nbsp;

#### apt-file find

- may need to install/refresh this tool
- may list packages that are not installed

```bash
sudo apt install apt-file
sudo apt-file update
apt-file find  <filename>
```

&nbsp;

### Install or Upgrade a Package

&nbsp;

#### Install/upgrade the _latest_ revision of a package

`sudo apt install <package>`

&nbsp;

#### Install/upgrade a _specific_ revision of a package

`sudo apt install <package>=<revision>`

&nbsp;

### List Available Revisions of a Package

`sudo apt-cache policy <package>`

&nbsp;

### List Packages

&nbsp;

#### List available packages

`apt list`

&nbsp;

#### List _installed_ packages

`apt list --installed`

&nbsp;

#### List _upgradable_ packages

`apt list --upgradable`

&nbsp;

### Manage Package-Repository Keys

#### Add a Missing Key

- Run this to resolve errors like:\
  `GPG error: ... The following signatures were invalid: EXPKEYSIG ...`
- Can point to a different key-server, as long it is a server you trust
- This format should work over firewalls/VPN as well

`sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys <KEY>`

&nbsp;

### Refresh the List of Available Packages

(does not change the configuration of the host -\
nothing is installed or upgraded except the packages-DB)

`sudo apt update`


&nbsp;

&nbsp;

