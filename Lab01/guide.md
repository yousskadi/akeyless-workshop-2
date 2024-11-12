# Environment Setup

- [Environment Setup](#environment-setup)
  - [1. Fork GitHub Repo](#1-fork-github-repo)
  - [2. Start a Codespace](#2-start-a-codespace)
  - [3. Run minikube](#3-run-minikube)
  - [4. Install ArgoCD](#4-install-argocd)
    - [Access ArgoCD](#access-argocd)
      - [Login to the UI](#login-to-the-ui)
      - [Login to the CLI](#login-to-the-cli)

## 1. Fork GitHub Repo

Go to this repo and fork it to your own GitHub account so you have full control over the CI/CD pipeline.

## 2. Start a Codespace

Start a GitHub Codespace on your forked repo.

## 3. Run minikube

```bash
minikube start
```

## 4. Install ArgoCD

Run the `install_script.sh` to install ArgoCD and Crossplane. It will also get Backstage ready. You'll need to create a few more configurations before running Backstage.

### Access ArgoCD

#### Login to the UI
To access ArgoCD, you will need the initial admin password. You can get it using the command below:

```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 --decode
```

And then use the username admin with this password to log in to ArgoCD.

You can port forward the service like this:

```bash
kubectl port-forward -n argocd service/argocd-server 8080:443
```

#### Login to the CLI

```bash
argocd login 127.0.0.1:8080 --username admin --password $(kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 --decode) --grpc-web --insecure
```

