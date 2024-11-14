# Akeyless Setup

- [Akeyless Setup](#akeyless-setup)
  - [1. Log into the Akeyless CLI with API Key](#1-log-into-the-akeyless-cli-with-api-key)
    - [Update the Default Akeyless Profile](#update-the-default-akeyless-profile)
    - [3.1 Test the Credentials with the CLI](#31-test-the-credentials-with-the-cli)
  - [4. Create a Target in Akeyless](#4-create-a-target-in-akeyless)
  - [5. Create a Rotated Secret for the Target](#5-create-a-rotated-secret-for-the-target)
  - [6. Create an AWS Dynamic Secret](#6-create-an-aws-dynamic-secret)


## 1. Log into the Akeyless CLI with API Key

### Update the Default Akeyless Profile

```bash
akeyless configure --profile default --access-id "$(jq -r .access_id ../creds_api_key_auth.json)" --access-key "$(jq -r .access_key ../creds_api_key_auth.json)"
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