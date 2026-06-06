# Kubernetes and Helm (WIP) <!-- omit in toc -->

Some basic Kubernetes and Helm workflows

- [Choose your Context (usually - Cluster)](#choose-your-context-usually---cluster)
- [Set a Default Namespace](#set-a-default-namespace)
  - [List Available Namespaces](#list-available-namespaces)
  - [Set Default Namespace](#set-default-namespace)
- [List Pods](#list-pods)
- [Helm](#helm)
  - [List Failing or Stuck (Deployment?)](#list-failing-or-stuck-deployment)
  - [Rollback a (Failing?) (Deployment?)](#rollback-a-failing-deployment)

## Choose your Context (usually - Cluster)

```bash
kubectl config get-contexts
...
kubectl config use-context <conntext>
```


## Set a Default Namespace

### List Available Namespaces

```bash
kubectl get namespace
```

### Set Default Namespace

```bash
kubectl config set-context --current --namespace=<namespace>
```

## List Pods

```bash
kubectl get pods
```

## Helm

### List Failing or Stuck (Deployment?)

```bash
helm list -n <namespace> -a | egrep "NAME|pending|failed"
```

### Rollback a (Failing?) (Deployment?)

```bash
helm rollback  -n <namespace> <chart> 0
```
