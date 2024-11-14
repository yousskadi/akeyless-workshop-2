# Akeyless Setup

- [Akeyless Setup](#akeyless-setup)
  - [1. Access Akeyless via OIDC](#1-access-akeyless-via-oidc)
    - [1.1 Login to Akeyless UI via OIDC](#11-login-to-akeyless-ui-via-oidc)
    - [1.2 Login to Akeyless CLI via OIDC](#12-login-to-akeyless-cli-via-oidc)
    - [1.3 Run a script to create an API Key and associate it with an Access Role](#13-run-a-script-to-create-an-api-key-and-associate-it-with-an-access-role)
  - [2. Create a Gateway in Akeyless](#2-create-a-gateway-in-akeyless)
    - [2.1 Create the Gateway](#21-create-the-gateway)
    - [2.2 Expose the Gateway Port 8000](#22-expose-the-gateway-port-8000)
    - [2.3 Give Permission](#23-give-permission)
    - [2.4 Check the Gateway from the Akeyless Console](#24-check-the-gateway-from-the-akeyless-console)


## 1. Access Akeyless via OIDC

### 1.1 Login to Akeyless UI via OIDC

Go to https://console.akeyless.io and click on `OIDC` and NOT `GitHub` under the `Sign in` button, then enter this `OIDC Access ID` `p-j1ej0z1eudthim` then click `Sign in`. This will redirect you to GitHub to login. You will need to approve the access.

![alt text](../images/login-oidc.png)

### 1.2 Login to Akeyless CLI via OIDC

```bash
akeyless auth --access-id=p-j1ej0z1eudthim --access-type=oidc --use-remote-browser
```

Output:
```
Open the link below in your browser in order to complete the authentication:
Link: https://auth.akeyless.io/oidc-login?access_id=p-j1ej0z1eudthim&redirect_uri=https://auth-relay.akeyless.io/creds-login&is_short_token=true
```

Click on the link above and login with your GitHub account.

Then you will get a screen that says the following:

![alt text](../images/oidc-auth-success.jpg)

Click on the `Show Token` button and copy the token and save it somewhere to be used in the next step.

![alt text](../images/copy-oidc-token.jpg)

### 1.3 Run a script to create an API Key and associate it with an Access Role
```bash
Lab03/create_api_key.sh
```

## 2. Create a Gateway in Akeyless

### 2.1 Create the Gateway

Run the following commands in the `Terminal` of your GitHub codespace.

```bash
helm repo add akeyless https://akeylesslabs.github.io/helm-charts
helm repo update
kubectl create namespace akeyless
helm upgrade --install gw akeyless/akeyless-api-gateway -f values.yaml -n akeyless
```

Check the gateway logs and wait until they stop:

```bash
docker logs -f akeyless-gw
```

Hit `Ctrl+C` to stop the logs.

### 2.2 Expose the Gateway Port 8000

Click on the `PORTS` tab beside the `TERMINAL` tab and right click on port `8000` and change the `Port Visibility` to `Public`.
![alt text](../images/port_visibility_public.png)

### 2.3 Give Permission

Login to the Gateway from your browser by clicking on the `PORTS` tab beside the `TERMINAL` tab and click the globe icon to open in a browser for port `8000`. 
![alt text](../images/port_open_gwy.png)

Approve the access to this port.

![alt text](../images/approve_port_access.png)

Login using your API key credentials found in the `creds_api_key_auth.json` file in Lab03.

![alt text](../images/gwy-sign-in.png)

![alt text](../images/gwy_view.png)

Click on `Access Permissions` then on the `New` button.

Give it a name `APIkey` and choose the `/Workshops/Workshop2/<your-name>/APIkey` Auth method then click `Next.` Leave `Admin` selected and then click `Finish`.

![alt text](../images/gwy-access-permissions.png)

Add another permission for the OIDC auth method: `/Workshops/TeKanAid Academy GitHub`

![alt text](../images/gwy-oidc-permissions.png)

then click `Next.` Leave `Admin` selected and then click `Finish`.

### 2.4 Check the Gateway from the Akeyless Console

Now refresh the Akeyless Console browser and click on the `Gateway` tab to see your gateway registered with the console.

![alt text](../images/console_view_with_gwy.png)

> You've reached the end of the lab.