# Setup Virtual Env ('venv' or 'virtualenv') <!-- omit in toc -->

Set a sandboxed Python environment \
(the preferred way to use Python in production)

### Table of Contents <!-- omit in toc -->
- [What is it good for](#what-is-it-good-for)
  - [Benefits of Using a Virtual Environment](#benefits-of-using-a-virtual-environment)
  - [Benefits of Using `venv`](#benefits-of-using-venv)
  - [Benefits of Using `virtualenv`](#benefits-of-using-virtualenv)
- [Prepare a Requirements File](#prepare-a-requirements-file)
  - [Note](#note)
- [Using `virtualenv`](#using-virtualenv)
  - [One-Time Effort](#one-time-effort)
    - [Setup the Host](#setup-the-host)
  - [Create and Use the Virtual-Env](#create-and-use-the-virtual-env)
    - [Choose a Name for the Virtual-Env](#choose-a-name-for-the-virtual-env)
    - [Create the Virtual-Env](#create-the-virtual-env)
    - [Initialize the Virtual-Env](#initialize-the-virtual-env)
    - [Install Required Python Packages on the Virtual-Env](#install-required-python-packages-on-the-virtual-env)
    - [Hide 'virtualenv' files from git](#hide-virtualenv-files-from-git)
  - [Exit the Virtual-Env](#exit-the-virtual-env)
- [Using `venv`](#using-venv)
  - [Create and Use the Virtual-Env](#create-and-use-the-virtual-env-1)
    - [Choose a Name for the Virtual-Env](#choose-a-name-for-the-virtual-env-1)
    - [Create the Virtual-Env](#create-the-virtual-env-1)
    - [Initialize the Virtual-Env](#initialize-the-virtual-env-1)
    - [Install Required Python Packages on the Virtual-Env](#install-required-python-packages-on-the-virtual-env-1)
    - [Hide 'venv' files from git](#hide-venv-files-from-git)
  - [Exit the Virtual-Env](#exit-the-virtual-env-1)
  - [Sample Source-File for Setting Up a Virtual-Env for Python 3.11](#sample-source-file-for-setting-up-a-virtual-env-for-python-311)

&nbsp;

## What is it good for

Both `venv` and `virtualenv` are tools for creating isolated Python environments, \
and they're quite similar in functionality.

See **[virtualenv Lives!](https://hynek.me/articles/virtualenv-lives/)** where it says, among other things:

> Setting up Python to the point to be able install packages \
> from PyPI can be annoying and time-intensive. \
> Even worse are OS-provided installations that start throwing cryptic error messages. \
> Especially desktops are prone to that but it’s possible to break the whole toolchain \
> of a server by installing some shiny package you heard about on reddit.

### Benefits of Using a Virtual Environment

- It allows you to create a separate environment for your Python projects, \
  which helps avoid conflicts between different projects' dependencies.
- It enables you to install packages without affecting the system Python installation, \
  which is especially useful if you don't have administrative privileges or \
  if you want to avoid breaking system packages.
- It makes it easier to manage dependencies for different projects, \
  as you can create a new environment for each project with its own set of packages.

### Benefits of Using `venv`

- `venv` is included in the Python standard library starting from Python 3.3, \
  so it's available by default with Python installations.
- `venv` is simpler and more lightweight, making it a good choice for basic use cases.
- `venv` is the recommended choice for most users, especially if you're using Python 3.3 or later.

### Benefits of Using `virtualenv`

- `virtualenv` is a third-party package that provides similar functionality and works with both Python 2 and 3.
- `virtualenv` is more feature-rich and has some additional capabilities compared to `venv`, \
  such as support for creating environments with different Python versions.
- `virtualenv` is also more widely used in the Python community, \
  especially in projects that need to support multiple Python versions.

&nbsp;

## Prepare a Requirements File

The requirements file should list all the packages to be installed in that virtual-env,\
as well as the specific version each should have, for example:\
requirements.txt

```toml
PyNaCl==1.2.0
PyYAML==3.12
```

- The list should reflect all required modules and their versions
- Make sure all modules are set to a specific version (with the `==` operator)

### Note

To confirm everything is set as required, the setup can be run every time before using the environment -\
if all is already configured, it will just verify that and continue.

&nbsp;

## Using `virtualenv`

### One-Time Effort

#### Setup the Host

`virtualenv` should be pre-installed as root:

```bash
sudo pip3 install virtualenv
```

### Create and Use the Virtual-Env

#### Choose a Name for the Virtual-Env

Set a folder-name (and location) for your virtual env

```bash
export VENV_DIR=<virtual-env-path-and-name>
```

#### Create the Virtual-Env

```bash
virtualenv "${VENV_DIR}"
```

#### Initialize the Virtual-Env

```bash
source "${VENV_DIR}/bin/activate"
```

#### Install Required Python Packages on the Virtual-Env

```bash
pip3 install -r ./requirements.txt
```

#### Hide 'virtualenv' files from git

To hide the **virtualenv** files from git, create a `.gitignore` file in the virtualenv folder:

```bash
echo "*\n" > "${VENV_DIR}/.gitignore"
```

### Exit the Virtual-Env

Case you would like to exit the virtualenv setup, `deactivate` it:

```bash
deactivate
```

&nbsp;

## Using `venv`

### Create and Use the Virtual-Env

#### Choose a Name for the Virtual-Env

Set a folder-name (and location) for your virtual env

```bash
export VENV_DIR=<virtual-env-path-and-name>
```

#### Create the Virtual-Env

```bash
python3.11 -m venv "${VENV_DIR}"
```

#### Initialize the Virtual-Env

```bash
source "${VENV_DIR}/bin/activate"
```

#### Install Required Python Packages on the Virtual-Env

```bash
# Optional: upgrade pip
# pip install --upgrade pip
pip install -r ./requirements.txt
```

#### Hide 'venv' files from git

To hide the **venv** files from git, create a `.gitignore` file in the venv folder:

```bash
echo "*\n" > "${VENV_DIR}/.gitignore"
```

### Exit the Virtual-Env

Case you would like to exit the virtualenv setup, `deactivate` it:

```bash
deactivate
```

### Sample Source-File for Setting Up a Virtual-Env for Python 3.11

```bash
# Set the Python version
PYTHON_VERSION=3.11
# Set the virtual environment directory
VENV_DIR=./venv_p${PYTHON_VERSION}
# Create the virtual environment
python${PYTHON_VERSION} -m venv "${VENV_DIR}"
# Activate the virtual environment
source "${VENV_DIR}/bin/activate"
# Upgrade pip
pip install --upgrade pip
# Install required packages
pip install -r ./requirements.txt
# Hide the virtual environment files from git
echo "*\n" > "${VENV_DIR}/.gitignore"

echo "To Deactivate the virtual environment, run:"
echo "'deactivate'"
```

See [setup_venv_python311.source](./setup_venv_python311.source)

&nbsp;
