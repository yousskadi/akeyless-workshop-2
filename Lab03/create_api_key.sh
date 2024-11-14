#!/bin/bash

echo "Please enter your name:"
read name
echo "Please enter your oidc token:"
read oidc_token
echo "Hello $name, saving your oidc token into the file token_oidc_auth.txt..."

echo $oidc_token > ../token_oidc_auth.txt

# Read token from token.txt
token=$(cat token_oidc_auth.txt)
echo "Creating an API key with the name /Workshops/Workshop2/$name/APIkey..."
akeyless auth-method create api-key --name /Workshops/Workshop2/$name/APIkey --token "$token" --json > ../creds_api_key_auth.json
echo "Writing your API key credentials into the file creds_api_key_auth.json"
echo "You will need these API key credentials when authenticating into the gateway later"

echo "Associating API key with access role..."
akeyless assoc-role-am --am-name "/Workshops/Workshop2/$name/APIkey" --role-name "/Workshops/Workshop2" --token "$token"