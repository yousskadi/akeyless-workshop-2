# Investigating the Flask App

- [Investigating the Flask App](#investigating-the-flask-app)
  - [1. Expose the Flask App](#1-expose-the-flask-app)
  - [2. Check the ArgoCD UI](#2-check-the-argocd-ui)
  - [3. Check the Flask App Logs in ArgoCD](#3-check-the-flask-app-logs-in-argocd)


## 1. Expose the Flask App

Run the following command to expose the Flask App:

```bash
kubectl port-forward svc/flask-todo 5000:80
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


> Congratulations on finishing this workshop! You've successfully deployed a Flask App that uses akeyless MySQL database and dynamically rotates the credentials using Akeyless.

> You've reached the end of the lab.
