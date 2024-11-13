#!/bin/bash

echo "Please enter your name:"
read name
echo "Hello $name, logging in via OIDC and creating API key..."

akeyless auth --access-id=p-j1ej0z1eudthim --access-type=oidc --json --jq-expression '.token' > token_oidc_auth.txt

# Read token from token.txt
token=$(cat token_oidc_auth.txt)
echo "Writing your akeyless token for authenticating with OIDC into the file token_oidc_auth.txt"

akeyless auth-method create api-key --name /Workshops/Workshop2/$name/APIkey --token "$token" --json > creds_api_key_auth.json
echo "Writing your API key credentials into the file creds_api_key_auth.json"
echo "You will need these API key credentials when authenticating into the gateway later"

echo "Associating API key with access role..."
akeyless assoc-role-am --am-name "/Workshops/Workshop2/$name/APIkey" --role-name "/Workshops/Workshop2" --token "$token"