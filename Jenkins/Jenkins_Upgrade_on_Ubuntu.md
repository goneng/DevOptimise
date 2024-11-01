# How to Upgrade Jenkins LTS Version <!-- omit in toc -->

- [Overview](#overview)
- [1. Check the Current Jenkins Version](#1-check-the-current-jenkins-version)
- [2. Check the Latest LTS Version](#2-check-the-latest-lts-version)
- [3. Lock the Jenkins-server via the UI](#3-lock-the-jenkins-server-via-the-ui)
- [4. Stop Jenkins Service](#4-stop-jenkins-service)
- [5. Backup Jenkins Data](#5-backup-jenkins-data)
- [6. Upgrade Jenkins and other Packages](#6-upgrade-jenkins-and-other-packages)
  - [6.1. Make sure the Jenkins-package is locked](#61-make-sure-the-jenkins-package-is-locked)
  - [6.2. Upgrade all other Linux-packages](#62-upgrade-all-other-linux-packages)
  - [6.3. Unlock Jenkins-package](#63-unlock-jenkins-package)
  - [6.4. Upgrade Jenkins](#64-upgrade-jenkins)
  - [6.5. Lock Jenkins-package](#65-lock-jenkins-package)
- [7. Start Jenkins Service](#7-start-jenkins-service)
- [8. Verify the Upgrade](#8-verify-the-upgrade)
- [9. When done, delete the snapshot](#9-when-done-delete-the-snapshot)


## Overview

For a Jenkins instance that is installed as a Linux package on Ubuntu.

## 1. Check the Current Jenkins Version

Before upgrading Jenkins, confirm the current version we are running, \
and compare it to the version we are currently using (via the Jenkins UI).

```bash
apt list --installed | grep jenkins
```

## 2. Check the Latest LTS Version

Visit the [Jenkins LTS Release Notes](https://www.jenkins.io/changelog-stable/) \
to see the latest LTS version available.

List all available versions of Jenkins in the package repository, \
to see the recent versions available for installation:

```bash
apt-cache madison jenkins
# or
apt-cache policy jenkins
```

## 3. Lock the Jenkins-server via the UI

This is to prevent new jobs from starting.

Wait a few minutes to confirm that running jobs had finished.

## 4. Stop Jenkins Service

Stop the Jenkins service to prevent any changes \
from being made to the data while upgrading.

```bash
sudo systemctl stop jenkins.service
```

## 5. Backup Jenkins Data

Take a snapshot of the Jenkins-server main disk, \
to ensure that you can restore the data in case of any issues.

## 6. Upgrade Jenkins and other Packages

### 6.1. Make sure the Jenkins-package is locked

```bash
apt-mark showhold
```

If the package is not "on-hold", lock it to prevent accidental upgrades:

```bash
sudo apt-mark hold jenkins
```

### 6.2. Upgrade all other Linux-packages

```bash
sudo apt update
sudo apt list --upgradable
# make sure there are no strange packages in the list
sudo apt upgrade
sudo apt autoremove
```

### 6.3. Unlock Jenkins-package

Unlock the Jenkins package to allow the installation of the new version:

```bash
sudo apt-mark unhold jenkins
```

### 6.4. Upgrade Jenkins

```bash
sudo apt upgrade jenkins=<new_version>  # like '2.462.3'
```
(This may start the Jenkins service automatically)

### 6.5. Lock Jenkins-package

Lock the Jenkins package to prevent accidental upgrades:

```bash
sudo apt-mark hold jenkins
```

## 7. Start Jenkins Service

Start the Jenkins service to apply the changes, unless it starts automatically:

```bash
sudo systemctl status jenkins.service
sudo systemctl start jenkins.service  # if not already running
```

## 8. Verify the Upgrade

Log-in to Jenkins' UI and check the Jenkins version \
to verify that the upgrade was successful.

Can also run this command:

```bash
java -jar jenkins-cli.jar -s http://localhost:8080/ version
```

## 9. When done, delete the snapshot

Wait until you are confident the upgrade went OK \
(or until it is too late to rollback the upgrade...)

&nbsp;
