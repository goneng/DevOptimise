# Install Ansible in a Virtual Env. (virtualenv) <!-- omit in toc -->

Set Ansible in a sandboxed Python environment\
(the preferred way to use Python/Ansible in production)

(See also [Setup VirtualEnv](./Set_Virtual-Env.md))

### Table of Contents <!-- omit in toc -->
- [Setup the Host](#setup-the-host)
- [Activate the Virtual-Env](#activate-the-virtual-env)
  - [Install Ansible on the Virtual-Env](#install-ansible-on-the-virtual-env)

## Setup the Host

`virtualenv` should be pre-installed as root:

```bash
sudo apt install python3
sudo apt install python3-pip
sudo -H pip3 install virtualenv
```

## Activate the Virtual-Env

Set a folder-name (and location) for your virtual env', then initialize it:

```bash
export VENV_ANSIBLE=~/VENV_Ansible_2.9
virtualenv --system-site-packages "${VENV_ANSIBLE}"
source "${VENV_ANSIBLE}/bin/activate"
```

### Install Ansible on the Virtual-Env

```bash
# Confirm you are in the context of the virtualenv
source "${VENV_ANSIBLE}/bin/activate"

# Choose a specific version of Ansible to install
pip3 install 'ansible==2.9.2'

# Confirm Ansible was installed OK
ansible --version
```
