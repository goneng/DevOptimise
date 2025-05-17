# Add Linux to OpenCore Boot Menu on macOS (Dual-Boot) <!-- omit in toc -->

#FIXME: Use this page as base: [Dual Boot Linux Mint 21.2 and macOS with OpenCore Legacy Patcher and OpenCore Bootpicker](https://tinkerdifferent.com/threads/dual-boot-linux-mint-21-2-and-macos-with-opencore-legacy-patcher-and-opencore-bootpicker.3115/)

**Tested on OpenCore 2.2.0 and Ubuntu 20.04 - and *Failed*...**

Setup OpenCore to boot into Linux (Ubuntu) from the OpenCore boot menu. \
This guide assumes you have OpenCore already setup and booting into macOS.

Initial setup:
- Intel-based macOS
- OpenCore is installed on the EFI partition.
- Linux is installed on a separate partition.
- Linux bootloader is installed on the EFI partition.
- Linux bootloader is `grubx64.efi` (default for Ubuntu).
- OpenCore config file is `config.plist`.

### Table of Contents <!-- omit in toc -->
- [1. Mount EFI Partition](#1-mount-efi-partition)
- [2. Backup OpenCore Config](#2-backup-opencore-config)
- [3. Add Linux Boot Entry](#3-add-linux-boot-entry)
- [4. Verify and Unmount](#4-verify-and-unmount)
- [5. Reboot](#5-reboot)
- [Recovery](#recovery)

&nbsp;

## 1. Mount EFI Partition
```bash
# List disks to find EFI partition
diskutil list
diskutil list | grep -i efi

# Mount EFI partition (usually disk0s1)
sudo diskutil mount disk0s1
```

## 2. Backup OpenCore Config
```bash
cd /Volumes/EFI/EFI/OC
cp -p config.plist config.plist.SAVE_$(date +%Y%m%d_%H%M%S)
```

## 3. Add Linux Boot Entry
Add the following entry to the `Misc -> Entries -> Array` section in `config.plist`:\
(may need to replace `<array/>` with `<array> ... </array>` tags)
```xml
<dict>
    <key>Arguments</key>
    <string></string>
    <key>Auxiliary</key>
    <false/>
    <key>Comment</key>
    <string>Ubuntu Linux</string>
    <key>Enabled</key>
    <true/>
    <key>Name</key>
    <string>Ubuntu</string>
    <key>Path</key>
    <string>/EFI/ubuntu/grubx64.efi</string>
</dict>
```

## 4. Verify and Unmount
```bash
# Verify config file is valid
plutil -lint /Volumes/EFI/EFI/OC/config.plist

# Unmount EFI partition
sudo diskutil unmount /Volumes/EFI
```

## 5. Reboot
Your OpenCore menu should now show Ubuntu as a boot option.

## Recovery
If boot fails, boot into macOS Recovery Mode and restore `config.plist.SAVE_...`.

&nbsp;
