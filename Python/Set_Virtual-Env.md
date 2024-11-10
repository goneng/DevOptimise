# Setup Virtual Env (virtualenv) <!-- omit in toc -->

Set a sandboxed Python environment\
(the preferred way to use Python in production)

### Table of Contents <!-- omit in toc -->
- [What is it good for](#what-is-it-good-for)
- [One-Time Effort](#one-time-effort)
  - [Setup the Host](#setup-the-host)
  - [Prepare a Requirements File](#prepare-a-requirements-file)
- [Create and Use the Virtual-Env](#create-and-use-the-virtual-env)
  - [Choose a Name for the Virtual-Env](#choose-a-name-for-the-virtual-env)
  - [Create the Virtual-Env](#create-the-virtual-env)
  - [Initialize the Virtual-Env](#initialize-the-virtual-env)
  - [Install Required Python Packages on the Virtual-Env](#install-required-python-packages-on-the-virtual-env)
- [Exit the Virtual-Env](#exit-the-virtual-env)

&nbsp;

## What is it good for

**virtualenv** is a tool that allows you to set an _isolated_ installation of Python,\
complete with the Python-executable and all the required modules.

To confirm everything is set as required, the setup can be run every time before using the environment -\
if all is already configured, it will just verify that and continue.

See **[virtualenv Lives!](https://hynek.me/articles/virtualenv-lives/)** where it says, among other things:

"Setting up Python to the point to be able install packages\
from PyPI can be annoying and time-intensive.\
Even worse are OS-provided installations that start throwing cryptic error messages.\
Especially desktops are prone to that but it’s possible to break the whole toolchain\
of a server by installing some shiny package you heard about on reddit."

&nbsp;

## One-Time Effort

### Setup the Host

`virtualenv` should be pre-installed as root:

```bash
sudo pip3 install virtualenv
```

### Prepare a Requirements File

The requirements file should list all the packages to be installed in that virtual-env,\
as well as the specific version each should have, for example:\
requirements.txt

```bash
PyNaCl==1.2.0
PyYAML==3.12
```

- The list should reflect all required modules and their versions
- Make sure all modules are set to a specific version (with the `==` operator)

&nbsp;

## Create and Use the Virtual-Env

### Choose a Name for the Virtual-Env

Set a folder-name (and location) for your virtual env

```bash
export VENV_DIR=<virtual-env-path-and-name>
```

### Create the Virtual-Env

```bash
virtualenv "${VENV_DIR}"
```

### Initialize the Virtual-Env

```bash
source "${VENV_DIR}/bin/activate"
```

### Install Required Python Packages on the Virtual-Env

```bash
pip3 install -r ./requirements.txt
```

&nbsp;

## Exit the Virtual-Env

Case you would like to exit the virtualenv, run this:

```bash
deactivate
```

&nbsp;
