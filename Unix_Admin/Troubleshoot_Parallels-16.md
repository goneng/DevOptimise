# Troubleshoot the Installation of Parallels 16.x on macOS Sonoma or Sequoia <!-- omit from toc -->

**Table of Contents**
- [Problem](#problem)
- [Quick Fix Process](#quick-fix-process)
  - [Step 1: Check Privacy \& Security Section (Legacy Location)](#step-1-check-privacy--security-section-legacy-location)
  - [Step 2: Check Login Items \& Extensions (New Location)](#step-2-check-login-items--extensions-new-location)
  - [Step 3: If No Permission Messages Appear](#step-3-if-no-permission-messages-appear)
- [Additional Troubleshooting](#additional-troubleshooting)
  - [If Parallels Still Won't Run](#if-parallels-still-wont-run)
  - [For Virtual Machine Networking Issues](#for-virtual-machine-networking-issues)
  - [Last Resort for Stubborn System Extensions](#last-resort-for-stubborn-system-extensions)
- [Note on Compatibility](#note-on-compatibility)

&nbsp;

## Problem

*Parallels 16.x* (and v17.x as well?) may fail to run properly on \
macOS *Sonoma*, *Sequoia* and newer (v14+) due to \
changes made to the *system extension* and *privacy settings* locations. \
The application might prompt for permissions but not work correctly because \
the permission dialogs are found in different locations compared to when Parallels 16 was released.

&nbsp;

## Quick Fix Process

### Step 1: Check Privacy & Security Section (Legacy Location)

1. Open System Settings (Apple menu > System Settings)
2. Navigate to **Privacy & Security** > **Security**
3. Look for messages like:
   - "Some system software requires your attention before it can be used"
   - "System software from application 'Parallels' was blocked from loading"
4. Click **Details...** or **Allow** if such messages are present
5. Authenticate with your password if prompted
6. Restart your Mac if required

### Step 2: Check Login Items & Extensions (New Location)

1. Open System Settings (Apple menu > System Settings)
2. Navigate to **General** > **Login Items & Extensions**
3. Look for Parallels extensions in the list
4. Enable any disabled Parallels extensions by toggling them on
5. Authenticate with your password if prompted
6. Restart your Mac if required

### Step 3: If No Permission Messages Appear

1. Try reinstalling Parallels to trigger the system extension prompts
2. When prompted that "System software was blocked," click "Open System Settings"
3. Follow either Step 1 or Step 2 depending on where the settings open
4. Complete the authentication and restart process

&nbsp;

## Additional Troubleshooting

### If Parallels Still Won't Run

Check if it requires full disk access:
1. Go to System Settings > Privacy & Security > Full Disk Access
2. Add Parallels to the list if it's not already there

### For Virtual Machine Networking Issues

Check if Parallels has all required network extension permissions:
1. Go to System Settings > Privacy & Security > Network
2. Ensure Parallels is allowed

### Last Resort for Stubborn System Extensions

For very difficult cases (only if the above doesn't work):
1. Restart in Recovery Mode (hold Power button on Apple Silicon Macs)
2. Open Startup Security Utility
3. Select "Reduced Security"
4. Check "Allow user management of kernel extensions from identified developers"
5. Restart and try permissions again

&nbsp;

## Note on Compatibility

While this playbook might help get *Parallels 16.x* working on macOS Sequoia, \
this is an older version running on a much newer OS. \
Consider upgrading to a current version of Parallels for full compatibility and support.

&nbsp;

---
*-- Prepared with the help of Claude 3.7*
