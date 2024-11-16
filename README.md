# Workshop 2: Deploy an App in Kubernetes with ArgoCD and Akeyless
This workshop guides participants through building and deploying a secure Flask application that implements dynamic secrets management using Akeyless within a Kubernetes environment. Through a series of hands-on labs, you'll learn how to implement modern cloud-native security practices and dynamic secrets in a real-world application scenario.

## What You'll Build
- A Flask Todo application that connects to MySQL using dynamically rotating credentials
- A secure secrets management infrastructure using Akeyless
- A GitOps-based deployment pipeline using ArgoCD

## Key Learning Objectives
1. **Environment Setup**: Learn to set up a development environment using GitHub Codespaces and minikube Kubernetes cluster
2. **GitOps with ArgoCD**: Configure and manage ArgoCD for continuous deployment
3. **Secrets Management**: Implement Akeyless for secure secrets handling, including:
   - OIDC authentication
   - API key management
   - Gateway setup and configuration
4. **Dynamic Secrets**: Create and manage dynamic MySQL credentials with automatic rotation
5. **Kubernetes Integration**: Configure Kubernetes authentication with Akeyless using service accounts

## Technical Components
- **Infrastructure**: GitHub Codespaces, minikube Kubernetes cluster
- **Application**: Flask Todo application with MySQL backend
- **Security**: Akeyless for secrets management
- **GitOps**: ArgoCD for GitOps-based deployments
- **Database**: MySQL with dynamic credential rotation
- **Authentication**: OIDC, API Key, and Kubernetes service account-based auth

## Key Features
- Zero-trust security model with dynamic secret rotation
- Automated deployment through GitOps
- Kubernetes-native authentication
- Real-time credential rotation with 15-second TTL to view secret rotation in action
- UI-based interaction for both application and infrastructure management

## Workshop Labs

1. [Lab 1: Environment Setup](Lab01/guide.md)
   - Fork repository and setup GitHub Codespace
   - Start minikube Kubernetes cluster
   - Configure environment settings

2. [Lab 2: Prepare ArgoCD](Lab02/guide.md)
   - Install ArgoCD in Kubernetes
   - Configure access and authentication
   - Set up initial admin credentials

3. [Lab 3: Akeyless Setup](Lab03/guide.md)
   - Configure OIDC authentication
   - Create and manage API keys
   - Set up Akeyless Gateway
   - Configure permissions

4. [Lab 4: Application Setup](Lab04/guide.md)
   - Create Kubernetes authentication method
   - Deploy Flask application
   - Configure dynamic secrets
   - Set up database connectivity

5. [Lab 5: Investigating the Flask App](Lab05/guide.md)
   - Explore the Flask application UI
   - Monitor deployment status in ArgoCD
   - Examine logs and secret rotation

## Prerequisites
- GitHub account
- Basic understanding of Kubernetes
- Familiarity with Python and Flask
- Basic understanding of container concepts

## Getting Started
Begin with [Lab 1: Environment Setup](Lab01/guide.md) to start your journey through the workshop.

## If Your Codespace Times Out or You Need to Restart

This is the order of what you need to do if your codespace times out or you need to restart:

### 1. Run the keep alive command
```bash
while true; do date; sleep 60; done
```

### 2. Run minikube
```bash
minikube start --cpus 3 --memory 8g
```

### 3. Get all pods
Check the status of all pods:
```bash
kubectl get pods -A
```
wait till they are all running.

### 4. Delete the Akeyless Gateway Replicaset which will restart it

If the Akeyless Gateway pods take a while to start, you can restart the replicaset.

```bash
kubectl delete replicaset gw-akeyless-api-gateway-<random-string> -n akeyless
```

### 5. Port forward the services

#### 5.1 ArgoCD UI
```bash
kubectl port-forward -n argocd service/argocd-server 3000:443
```
Remember to set the port protocol to HTTPS in the Ports tab.

#### 5.2 Akeyless Gateway
```bash
kubectl port-forward svc/gw-akeyless-api-gateway 8000:8000 -n akeyless
```
Remember to set the port visibility to Public in the Ports tab.

#### 5.3 Akeyless API
```bash
kubectl port-forward svc/gw-akeyless-api-gateway 8081:8081 -n akeyless
```
Remember to set the port visibility to Public in the Ports tab.

#### 5.4 Flask Application
```bash
kubectl port-forward svc/flask-todo 5000:80 -n flask-todo
```

### 6. Login to the Akeyless Gateway UI

This will reset the connection between the Gateway and the Akeyless Console.

### 7. Login to ArgoCD

- Username: `admin`
- Password: `kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 --decode`

### 8. [Optional] Login to the Akeyless Console

Use the following OIDC Access ID when logging into Akeyless via OIDC (both UI and CLI).
`p-j1ej0z1eudthim`


## Troubleshooting
### Delete Kubernetes Auth Method and Gateway Config from the CLI

```bash
akeyless gateway-delete-k8s-auth-config -n /Workshops/Workshop2/<your-github-username>/k8s-auth-method
akeyless auth-method delete -n /Workshops/Workshop2/<your-github-username>/k8s-auth-method
```

You can then recreate them by running the script `Lab04/create-kubernetes-auth-method.sh`.


