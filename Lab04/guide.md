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
  - [3. Log into the Akeyless CLI](#3-log-into-the-akeyless-cli)
    - [Update the Default Akeyless Profile](#update-the-default-akeyless-profile)
    - [3.1 Test the Credentials with the CLI](#31-test-the-credentials-with-the-cli)
  - [4. Create a Target in Akeyless](#4-create-a-target-in-akeyless)
  - [5. Create a Rotated Secret for the Target](#5-create-a-rotated-secret-for-the-target)
  - [6. Create an AWS Dynamic Secret](#6-create-an-aws-dynamic-secret)


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
docker run -d -p 8000:8000 -p 8200:8200 -p 18888:18888 -p 8080:8080 -p 8081:8081 -p 5696:5696 --name akeyless-gateway akeyless/base:latest-akeyless
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

## 3. Log into the Akeyless CLI

### Update the Default Akeyless Profile

Fill in the API Key values obtained from step 1.1 below and run the commands:

```bash
export AKEYLESS_ACCESS_ID=xxx
export AKEYLESS_ACCESS_KEY=xxx
akeyless configure --profile default --access-id ${AKEYLESS_ACCESS_ID} --access-key ${AKEYLESS_ACCESS_KEY}
```

### 3.1 Test the Credentials with the CLI

Run the following command to test the CLI access to Akeyless

```bash
akeyless list-gateways
```

Sample output:
```json
{
  "clusters": [
    {
      "id": 50053,
      "cluster_name": "acc-me6ozktdv0Tm/p-4vou9psc6dyxem/defaultCluster",
      "cluster_url": "https://curly-halibut-vg5g75v9jj4h4gw-8000.app.github.dev",
      "status": "Running",
      "status_description": "",
      "display_name": "",
      "allowed": false,
      "default_protection_key_id": 0,
      "default_secret_location": "",
      "allowed_access_ids": [
        "p-4vou9psc6dyxem"
      ]
    }
  ]
}
```

## 4. Create a Target in Akeyless

You will need the AWS credentials you received in the beginning to create a target in Akeyless. You can find them by running:

```bash
cat ~/.aws/credentials
```

Then run the command below with your AWS credentials replacing the placeholders.
```bash
akeyless create-aws-target --name AWS --access-key-id <aws_access_key_id> --access-key <aws_secret_access_key> --region us-east-1
```

Example:
```bash
akeyless create-aws-target --name AWS --access-key-id AKIAQWXXXXXX --access-key duG1kRDPXXXX --region us-east-1
```

Go to the Akeyless Console and check the newly created Target that we will use to create an AWS dynamic secret. Go to the `Targets` tab.
![alt text](../images/targets.png)

## 5. Create a Rotated Secret for the Target

Since we always say not to have any long-lived credentials. Let's create a rotated secret that will rotate our Target's AWS credentials automatically every 30 days.

Run the following command:

```bash
akeyless rotated-secret create aws \
--name /Terraform/aws-target-rotated \
--target-name /AWS \
--rotator-type target \
--auto-rotate true \
--rotation-interval 30 \
--rotation-hour 10
```

Check the Akeyless UI to see the configuration there. Go to `Items` and search for `/Terraform/aws-target-rotated`.

![alt text](../images/target-rotated.png)

You could also manually rotate the credentials as shown below.

![alt text](../images/manual-rotate-target-creds.png)

## 6. Create an AWS Dynamic Secret

Now it's time to create our AWS Dynamic Secret. You will need to update the command below with your `gateway-url`. You can find it by going into your Akeyless Console and click on `Gateways` and it's under `Gateway URL (Configuration):`

![alt text](../images/gateway_url.png)

```bash
akeyless dynamic-secret create aws \
--name /Terraform/terraform-credentials \
--target-name AWS \
--gateway-url 'https://<Your-Akeyless-GW-URL:8000>' \
--aws-access-mode iam_user \
--aws-user-groups Akeyless-Workshops
```

Example:

```bash
akeyless dynamic-secret create aws \
--name /Terraform/terraform-credentials \
--target-name AWS \
--gateway-url 'https://curly-halibut-vg5g75v9jj4h4gw-8000.app.github.dev' \
--aws-access-mode iam_user \
--aws-user-groups Akeyless-Workshops
```

Now test this by fetching a dynamic AWS secret value using this command:

```bash
akeyless dynamic-secret get-value --name /Terraform/terraform-credentials
```


> You've reached the end of the lab.