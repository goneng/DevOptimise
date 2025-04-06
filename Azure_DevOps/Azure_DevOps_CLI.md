# Azure DevOps CLI Tips  <!-- omit in toc -->

- [Basic Use](#basic-use)
  - [Installation](#installation)
  - [Login](#login)
  - [Set Default Organization and Project](#set-default-organization-and-project)
  - [Create a New Project](#create-a-new-project)
  - [List Work Items](#list-work-items)
  - [Create a New Repository](#create-a-new-repository)
  - [Clone a Repository](#clone-a-repository)
  - [Create a New Pipeline](#create-a-new-pipeline)
  - [Run a Pipeline](#run-a-pipeline)
  - [Help](#help)

&nbsp;

## Basic Use

### Installation

You can install the Azure DevOps extension for Azure CLI using the command

```bash
az extension add --name azure-devops
```

### Login

Before you start using the ADO CLI, login using the command

```bash
az login
```

### Set Default Organization and Project

To avoid specifying the organization and project for every command, \
you can set them as default using

```bash
az devops configure --defaults organization=https://dev.azure.com/myorg/ project=myproject
```

*Replace the placeholders with your actual organization, and project names.*

### Create a New Project

Create a new project using the command

```bash
az devops project create --name
```

### List Work Items

List all work items in a project using the command

```bash
az boards work-item list --project
```

### Create a New Repository

Create a new repository using the command

```bash
az repos create --name
```

### Clone a Repository

Clone a repository using the command

```bash
az repos clone --name
```

### Create a New Pipeline

Create a new pipeline using the command

```bash
az pipelines create --name
```

### Run a Pipeline

Run a pipeline using the command

```bash
az pipelines run --name
```

### Help

If you need help with a command, you can use the `--help` flag, \
for example:

```bash
az devops --help
```

&nbsp;
