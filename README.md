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

