# Prepare ArgoCD

- [Prepare ArgoCD](#prepare-argocd)
  - [1. Install ArgoCD](#1-install-argocd)
  - [2. Get the initial admin password](#2-get-the-initial-admin-password)
  - [3. Port forward the service](#3-port-forward-the-service)
  - [4. Login to the ArgoCD UI](#4-login-to-the-argocd-ui)
  - [5. Login to the CLI](#5-login-to-the-cli)

## 1. Install ArgoCD

```bash 
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## 2. Get the initial admin password

To access ArgoCD, you will need the initial admin password. You can get it using the command below:

```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 --decode
```

## 3. Port forward the service

You can port forward the service like this:

```bash
kubectl port-forward -n argocd service/argocd-server 8080:443
```

## 4. Login to the ArgoCD UI

Use the username `admin` with this password to log in to ArgoCD.

## 5. Login to the CLI

```bash
argocd login 127.0.0.1:8080 --username admin --password $(kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 --decode) --grpc-web --insecure
```
