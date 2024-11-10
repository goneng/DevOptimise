# Change Hostname (Rename a Host) - macOS <!-- omit in toc -->

Best-practices for naming hosts

(from [AskDifferent: Set the hostname/computer name for macOS](https://apple.stackexchange.com/a/287775/28372) \
and [AutoDesk's Support doc.: How to set the Mac hostname or computer name from the terminal](https://knowledge.autodesk.com/support/smoke/learn-explore/caas/sfdcarticles/sfdcarticles/Setting-the-Mac-hostname-or-computer-name-from-the-terminal.html))

### Table of Contents <!-- omit in toc -->
- [Choose a Valid Hostname](#choose-a-valid-hostname)
- [Check the Current Hostname](#check-the-current-hostname)
- [Set a New Hostname](#set-a-new-hostname)
- [Optional: Assign a Loopback Address to the Hostname](#optional-assign-a-loopback-address-to-the-hostname)
- [Reboot](#reboot)
- [Check the (New) Hostname](#check-the-new-hostname)

## Choose a Valid Hostname

- Use `a-z`, `A-Z`, `0-9`, and hyphen (`-`) characters only
- Avoid underscores (`_`), spaces, and other symbols
- Do not start a host-name with a number
- Do not end a host-name with a hyphen

## Check the Current Hostname

To list the existing name(s) of this machine \
open a Terminal window and run the following commands

```bash
scutil --get HostName
scutil --get LocalHostName
scutil --get ComputerName
```

## Set a New Hostname

To change the hostname of this machine \
open a Terminal window and run the following commands


```bash
NEW_HOSTNAME=<New-Name>
sudo scutil --set HostName $NEW_HOSTNAME
sudo scutil --set LocalHostName $NEW_HOSTNAME
sudo scutil --set ComputerName $NEW_HOSTNAME
dscacheutil -flushcache
```

## Optional: Assign a Loopback Address to the Hostname

To ensure that the DNS domain name and FQDN of the machine are reported back correctly,\
change the following line of the `/etc/hosts` file to include the FQDN and host-name as\
the first two entries:

```
127.0.0.1 hostname-fqdn hostname localhost
```

For example:

```
127.0.0.1 my-server.example.com my-server localhost
```

Remove any other references to hostname-fqdn or hostname from other entries in the file.

## Reboot

Reboot the server so the changes will take effect,\
for example:

```bash
sudo reboot
```

## Check the (New) Hostname

See above - [Check the Current Hostname](#check-the-current-hostname)

