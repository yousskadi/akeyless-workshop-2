# Investigating the Flask App

This lab will help you investigate how the Flask App works with Akeyless dynamic secrets and the MySQL database.

Key Objectives:
- Expose and interact with the Flask App UI
- View the application deployment status in ArgoCD
- Examine the Flask App logs to understand dynamic secret rotation

Table of Contents:


- [Investigating the Flask App](#investigating-the-flask-app)
  - [1. Expose the Flask App](#1-expose-the-flask-app)
  - [2. Check the ArgoCD UI](#2-check-the-argocd-ui)
  - [3. Check the Flask App Logs in ArgoCD](#3-check-the-flask-app-logs-in-argocd)
  - [4. Find the Easter Egg](#4-find-the-easter-egg)


## 1. Expose the Flask App

Run the following command to expose the Flask App:

```bash
kubectl port-forward svc/flask-todo 5000:80 -n flask-todo
```

Now as usual, go to the ports section in your codespace and click on the globe icon on the Port `5000` line to open the Flask App in a new tab. You should see the following page:

![Flask App](../images/flask-app.png)


## 2. Check the ArgoCD UI

You should still be logged into ArgoCD UI from lab 02. Our application should be deployed and healthy.

![ArgoCD UI](../images/argocd-app-ready.png)

## 3. Check the Flask App Logs in ArgoCD

Now click on the application card and then on the pod card as shown below:

![ArgoCD UI](../images/argocd-app-details.png)

Finally click on the `Logs` tab to see the Flask App logs.

![Flask App Logs](../images/flask-app-logs.png)

Now notice how the logs are showing how the Flask App is using the MySQL database and requests new dynamic secrets from Akeyless for the MySQL credentials. Remember we set the TTL for the dynamic secret to 15 seconds.

Interact with the Flask App by adding and deleting todo items to see how the dynamic secrets are being rotated.

## 4. Find the Easter Egg

Try adding a todo item with the text "Akeyless secured my app" for a surprise! 🔐

> Congratulations on finishing this workshop! You've successfully deployed a Flask App that uses akeyless MySQL database and dynamically rotates the credentials using Akeyless.

> You've reached the end of the lab.
