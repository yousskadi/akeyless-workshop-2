# Application Setup

- [Application Setup](#application-setup)
  - [1. Create a K8s Auth Method in Akeyless](#1-create-a-k8s-auth-method-in-akeyless)
  - [2. Expose port 8081](#2-expose-port-8081)
  - [3. Run the deploy script](#3-run-the-deploy-script)
  - [4. Spend some time exploring the script](#4-spend-some-time-exploring-the-script)

## 1. Create a K8s Auth Method in Akeyless

Run the following script to create a K8s Auth Method in Akeyless:

```bash
Lab04/create-k8s-auth.sh
```
## 2. Expose port 8081

Run the following command to expose port 8081 which runs the akeyless api:

```bash
kubectl port-forward svc/gw-akeyless-api-gateway 8081:8081
```

## 3. Run the deploy script

Run the following command from the root of the repository in a terminal window to deploy the application:

```bash
Lab04/deploy-flask-todo.sh
```

## 4. Spend some time exploring the script

Read through the script `deploy-flask-todo.sh` and understand what it does.

> You've reached the end of the lab.