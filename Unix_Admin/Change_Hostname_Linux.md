# Change Hostname (Rename a Host) - Linux <!-- omit in toc -->

Best-practices for naming hosts

(from [Citrix: Install Linux Virtual Delivery Agent for Ubuntu](https://docs.citrix.com/en-us/linux-virtual-delivery-agent/current-release/installation-overview/ubuntu.html) \
and [He, Peng: Change the Username and Hostname on Ubuntu](https://hepeng.me/changing-username-and-hostname-on-ubuntu/))

### Table of Contents <!-- omit in toc -->
- [Prerequisites](#prerequisites)
- [Choose a Valid Hostname](#choose-a-valid-hostname)
- [Change the Hostname](#change-the-hostname)
- [Assign a Loopback Address to the Hostname](#assign-a-loopback-address-to-the-hostname)
- [Reboot](#reboot)
- [Check the host name](#check-the-host-name)
  - [Verify that the host-name is set correctly](#verify-that-the-host-name-is-set-correctly)
  - [Verify that the FQDN is set correctly](#verify-that-the-fqdn-is-set-correctly)
- [Optional - Disable multicast DNS](#optional---disable-multicast-dns)

## Prerequisites

- It is best the network is connected and configured correctly before proceeding
- If you are using a _Ubuntu 18.04 Live Server_, make the following change in the `/etc/cloud/cloud.cfg`\
    configuration file before setting the host name:\
    `preserve_hostname: true`

## Choose a Valid Hostname

- Use `a-z`, `A-Z`, `0-9`, and hyphen (`-`) characters only
- Avoid underscores (`_`), spaces, and other symbols
- Do not start a host-name with a number
- Do not end a host-name with a hyphen

## Change the Hostname

To ensure that the host-name of the machine is reported correctly,\
change the `/etc/hostname` file to contain _only the host-name_ of the machine,\
i.e.: NOT the FQDN (Fully-Qualified Domain Name).

```bash
sudo nano /etc/hostname
```

## Assign a Loopback Address to the Hostname

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

## Check the host name

### Verify that the host-name is set correctly

run:

```bash
hostname
```

This command should return only the host-name of the machine and not its FQDN.

### Verify that the FQDN is set correctly

run:

```bash
hostname -f
```

This command returns the FQDN of the machine.

## Optional - Disable multicast DNS

The default settings have multicast DNS (mDNS) enabled,\
which can lead to inconsistent name resolution results.

To disable mDNS, edit `/etc/nsswitch.conf` and change the line containing:

```text
hosts: files mdns_minimal [NOTFOUND=return] dns
```

To:

```text
hosts: files dns
```
