# Comprehensive Guide: Setting Up Dual-Boot Intel Mac with OpenCore <!-- omit in toc -->

### Table Of Contents <!-- omit in toc -->
- [Prerequisites](#prerequisites)
- [Step 1: Preparation and Backup](#step-1-preparation-and-backup)
  - [1.1 Backup Your System](#11-backup-your-system)
  - [1.2 Download Required Software](#12-download-required-software)
- [Step 2: macOS Installation](#step-2-macos-installation)
  - [2.1 Install Base macOS](#21-install-base-macos)
  - [2.2 Configure APFS Container](#22-configure-apfs-container)
  - [2.3 Install Additional macOS Versions](#23-install-additional-macos-versions)
  - [2.4 Configure OpenCore Boot Menu](#24-configure-opencore-boot-menu)
- [Step 3: Linux Installation Preparation](#step-3-linux-installation-preparation)
  - [3.1 Create Linux Installation Media](#31-create-linux-installation-media)
  - [3.2 Prepare Linux Partition](#32-prepare-linux-partition)
- [Step 4: Linux Installation](#step-4-linux-installation)
  - [4.1 Boot to Linux Installer](#41-boot-to-linux-installer)
  - [4.2 Install Linux](#42-install-linux)
- [Step 5: OpenCore Configuration](#step-5-opencore-configuration)
  - [5.1 Mount EFI Partition](#51-mount-efi-partition)
  - [5.2 Backup OpenCore Configuration](#52-backup-opencore-configuration)
  - [5.3 Configure OpenLinuxBoot](#53-configure-openlinuxboot)
- [Step 6: Testing and Verification](#step-6-testing-and-verification)
  - [6.1 Initial Testing](#61-initial-testing)
  - [6.2 Troubleshooting](#62-troubleshooting)
- [Additional Notes](#additional-notes)
  - [Performance Optimization](#performance-optimization)
  - [Maintenance](#maintenance)
  - [Security Considerations](#security-considerations)
- [Troubleshooting Common Issues](#troubleshooting-common-issues)
  - [Boot Issues](#boot-issues)
  - [Performance Issues](#performance-issues)
  - [Recovery Options](#recovery-options)

&nbsp;

## Prerequisites

Before starting, ensure you have:
- An Intel-based Mac (unibody model)
- USB drive (minimum 8GB) for Linux installation media
- OpenCore Legacy Patcher (OCLP) downloaded
- Linux ISO downloaded (Ubuntu or whatever)
- External drive for Time Machine backup
- Basic familiarity with Terminal commands
- Administrator access to your Mac

## Step 1: Preparation and Backup

### 1.1 Backup Your System

1. Connect an external drive
2. Open Time Machine preferences
3. Select your external drive as backup destination
4. Wait for initial backup to complete
5. Verify backup by browsing it in Finder

### 1.2 Download Required Software

1. Download OpenCore Legacy Patcher from: https://github.com/dortania/OpenCore-Legacy-Patcher/releases
2. Download Linux ISO
3. Verify downloads using provided checksums (SHA256)

## Step 2: macOS Installation

### 2.1 Install Base macOS

1. Start with clean installation of latest natively supported macOS
   - For 2015 MBP, this is Monterey
   - Use macOS Recovery (Command + R at startup)
   - Format drive as APFS during installation
   - Complete initial setup

### 2.2 Configure APFS Container

1. Open Disk Utility
2. Select your drive
3. Click "Partition" or "Volume"
4. Create new APFS volume for additional macOS versions
   - Click "+" button
   - Name it descriptively (e.g., "Ventura")
   - Keep format as APFS
   - Don't set size (let it share space)

### 2.3 Install Additional macOS Versions

1. Launch OpenCore Legacy Patcher
2. Select "Create macOS Installer"
3. Choose desired macOS version
4. Follow OCLP prompts to create installer
5. Install to new APFS volume
6. Repeat for each additional macOS version

### 2.4 Configure OpenCore Boot Menu

1. Open OCLP
2. Click "Post Install Root Patch"
3. Enable "Show OpenCore Boot Picker"
4. Apply patches
5. Restart to verify boot picker shows all macOS installations

## Step 3: Linux Installation Preparation

### 3.1 Create Linux Installation Media

1. Insert USB drive (8GB+)
2. Open Disk Utility
3. Select USB drive
4. Click "Erase"
   - Name: "LINUX_INSTALL"
   - Format: MS-DOS (FAT)
   - Scheme: GUID Partition Map
5. Use `dd` command in Terminal to write ISO:
   ```bash
   sudo dd if=/path/to/linux.iso of=/dev/rdiskN bs=1m
   ```
   Replace N with your USB drive number (find using `diskutil list`)

### 3.2 Prepare Linux Partition

1. Open Disk Utility
2. Select your main drive
3. Click "Partition"
4. Create new partition for Linux
   - Size: At least 30GB recommended
   - Format: MS-DOS (FAT)
   - Name: "LINUX"
5. Apply changes

## Step 4: Linux Installation

### 4.1 Boot to Linux Installer

1. Restart Mac holding Option key
2. Select USB drive (usually labeled "EFI Boot")
3. Choose "Start Linux"

### 4.2 Install Linux

1. Click "Install Linux"
2. Choose language and keyboard layout
3. Select "Something else" for installation type
4. Find your prepared partition (labeled "LINUX")
5. Set up partitions:
   - Root (/) : Most of space (ext4)
   - Swap : 8GB or equal to RAM
   - EFI : Use existing
6. Set bootloader location to EFI partition
7. Complete installation but when prompted to restart:
   - Click "Continue Testing" instead of restarting
   - Open Terminal in the live environment
   - Note down the path to your GRUB EFI file:
     ```bash
     # Temporary mount EFI partition is under /target/...
     # because we still in "Linux-live" mode
     ls /target/boot/efi/EFI/ubuntu/grubx64.efi
     ```
   - This confirms GRUB was installed correctly
8. Now you can safely restart

## Step 5: OpenCore Configuration

### 5.1 Mount EFI Partition

1. Hold Option key during restart
2. Select your main macOS drive to boot back to macOS
2. Open Terminal
3. Mount EFI:
   ```bash
   # List disks to find EFI partition
   diskutil list
   diskutil list | grep -i efi

   # Mount EFI partition (usually disk0s1)
   sudo diskutil mount disk0s1
   ```

### 5.2 Backup OpenCore Configuration

```bash
sudo ls -la /Volumes/EFI/EFI/OC/
sudo cp /Volumes/EFI/EFI/OC/config.plist /Volumes/EFI/EFI/OC/config.plist.SAVE_$(date +%Y%m%d_%H%M%S)
```

### 5.3 Configure OpenLinuxBoot

1. Set up required EFI drivers:
   - Download [`ext4_x64.efi`](https://github.com/acidanthera/OcBinaryData/blob/master/Drivers/ext4_x64.efi) from: https://github.com/acidanthera/OcBinaryData/tree/master/Drivers
   - Mount EFI partition if not already mounted:
     ```bash
     sudo diskutil mount EFI
     ```
   - Copy `ext4_x64.efi` to `/Volumes/EFI/EFI/OC/Drivers/`
   - Verify `OpenLinuxBoot.efi` exists in the same directory (should be there by default with OCLP)

2. Edit config.plist:
   - Open `/Volumes/EFI/EFI/OC/config.plist` with your preferred editor
   - Navigate to the ***Drivers*** section
   - Verify `OpenLinuxBoot.efi` entry exists
   - Add new entry for `ext4_x64.efi` (copy existing entry format)
   - **Important:** \
     Ensure `ext4_x64.efi` is listed BEFORE `OpenLinuxBoot.efi`

3. Verify these settings are enabled in config.plist:
   - `RequestBootVarRouting`: `true`
   - `LauncherOption`: `Full` (or `true`)
   - `HideAuxiliary`: `true`

4. Additional required settings:
   - Under Misc -> Security:
     - Set `ScanPolicy` to `0` to enable scanning for Linux partitions
     - Keep `ExposeSensitiveData` at `15` (or 0x0F in hex)
     - Set `AllowSetDefault` to `true`

5. Save changes

6. Validate the file and verify file-permissions remain unchanged
   ```bash
   # Verify config file is valid
   plutil -lint /Volumes/EFI/EFI/OC/config.plist

   # Confirm file permissions
   ls -la /Volumes/EFI/EFI/OC/config.plist*

   # Confirm which changes were made
   diff /Volumes/EFI/EFI/OC/config.plist.SAVE_* /Volumes/EFI/EFI/OC/config.plist
   ```
7. Unmount EFI partition
   ```bash
   # Unmount EFI partition
   sudo diskutil unmount /Volumes/EFI
   ```

Note: If you used a different filesystem for Linux installation (not ext4), you'll need to download and use the corresponding filesystem driver instead of ext4_x64.efi.

## Step 6: Testing and Verification

### 6.1 Initial Testing

1. Restart computer
2. Verify OpenCore boot picker appears
3. Test boot into each OS:
   - Each macOS version
   - Linux deployment
4. Verify basic functionality in each OS

### 6.2 Troubleshooting

If boot fails:
1. Hold Option key during startup
2. Boot to recovery partition
3. Mount EFI partition
4. Restore config.backup.plist to config.plist

## Additional Notes

### Performance Optimization

- Keep at least 20% free space in APFS container
- Regular TRIM for SSD (enabled by default in modern macOS)
- Consider disabling unnecessary startup items

### Maintenance

- Regularly update both operating systems
- Keep OCLP updated
- Maintain backups of both systems
- Document any custom configurations

### Security Considerations

- Enable FileVault for macOS volumes if needed
- Configure LUKS encryption for Linux
- Set firmware password if required
- Keep EFI partition secure

## Troubleshooting Common Issues

### Boot Issues

- No boot picker: Hold Option key during startup
- Missing OS: Verify config.plist entries
- Linux not booting: Check GRUB configuration

### Performance Issues

- Slow switching: Check free space and fragmentation
- Battery drain: Update power management in Linux
- Graphics glitches: Verify OCLP patches

### Recovery Options

1. OpenCore Recovery:
   - Hold Option during boot
   - Select Recovery
   - Restore from backup

2. Linux Recovery:
   - Boot from Linux USB
   - Use live environment for repairs
   - Check boot-repair utility

Remember to always maintain backups and document any changes you make to the system configuration.

---

&nbsp;
