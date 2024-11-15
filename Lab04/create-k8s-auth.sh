#!/bin/bash

# Exit on error
set -e

akeyless configure --profile default --access-id "$(jq -r .access_id creds_api_key_auth.json)" --access-key "$(jq -r .access_key creds_api_key_auth.json)"

# Get repository information from git
REPO_URL=$(git config --get remote.origin.url)
REPO_NAME=$(echo $REPO_URL | grep -o 'github.com[:/][^.]*' | sed 's#github.com[:/]##')
GITHUB_USERNAME=$(echo $REPO_NAME | cut -d'/' -f1)
# Get Codespace name and construct Akeyless Gateway URL
CODESPACE_NAME=$(gh codespace list --json name,repository -q ".[] | select(.repository==\"${REPO_NAME}\") | .name")
if [ -z "$CODESPACE_NAME" ]; then
    echo "Error: Could not find codespace for repository ${REPO_NAME}"
    exit 1
fi

CODESPACE_DOMAIN="app.github.dev"
AKEYLESS_GATEWAY_URL="https://${CODESPACE_NAME}-8000.${CODESPACE_DOMAIN}"

echo "Creating ServiceAccount and ClusterRoleBinding..."
cat << EOF > akl_gw_token_reviewer.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gateway-token-reviewer
  namespace: akeyless
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: role-tokenreview-binding
  namespace: akeyless
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: gateway-token-reviewer
  namespace: akeyless
EOF

kubectl apply -f akl_gw_token_reviewer.yaml

echo "Creating long-lived ServiceAccount token..."
cat << EOF > akl_gw_token_reviewer_token.yaml
apiVersion: v1
kind: Secret
metadata:
  name: gateway-token-reviewer-token
  namespace: akeyless
  annotations:
    kubernetes.io/service-account.name: gateway-token-reviewer
type: kubernetes.io/service-account-token
EOF

kubectl apply -f akl_gw_token_reviewer_token.yaml

echo "Waiting for token secret to be ready..."
for i in {1..30}; do
    if kubectl get secret gateway-token-reviewer-token -n akeyless -o jsonpath='{.data.token}' &>/dev/null; then
        echo "Token secret is ready"
        break
    fi
    echo "Waiting for token secret... ($i/30)"
    sleep 2
done

# Debug output
echo "Listing secrets in akeyless namespace:"
kubectl get secrets -n akeyless

echo "Extracting ServiceAccount JWT Bearer Token..."
SA_JWT_TOKEN=$(kubectl get secret gateway-token-reviewer-token -n akeyless \
  --output 'go-template={{.data.token | base64decode}}')

if [ -z "$SA_JWT_TOKEN" ]; then
    echo "Error: Failed to get JWT token"
    exit 1
fi

echo "Extracting K8s Cluster CA Certificate..."
CA_CERT=$(kubectl config view --raw --minify --flatten \
  --output 'jsonpath={.clusters[].cluster.certificate-authority-data}')

echo "Creating K8s Auth Method..."
AUTH_RESPONSE=$(akeyless create-auth-method-k8s -n "/Workshops/Workshop2/${GITHUB_USERNAME}/k8s-auth-method" --json)
ACCESS_ID=$(echo $AUTH_RESPONSE | jq -r .access_id)
PRV_KEY=$(echo $AUTH_RESPONSE | jq -r .prv_key)

echo "Extracting K8s issuer..."
K8S_ISSUER=$(kubectl proxy --api-prefix=/k8s-api & \
  sleep 2 && \
  curl -s http://localhost:8001/k8s-api/.well-known/openid-configuration | \
  jq -r .issuer && \
  kill %1)

# Get cluster endpoint
K8S_HOST=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

echo "Creating K8s Gateway Auth Config..."
akeyless gateway-create-k8s-auth-config \
  --name "/Workshops/Workshop2/${GITHUB_USERNAME}/k8s-auth-config" \
  --gateway-url "$AKEYLESS_GATEWAY_URL" \
  --access-id "$ACCESS_ID" \
  --signing-key "$PRV_KEY" \
  --k8s-host "$K8S_HOST" \
  --token-reviewer-jwt "$SA_JWT_TOKEN" \
  --k8s-ca-cert "$CA_CERT" \
  --k8s-issuer "$K8S_ISSUER"

# Save access ID to a file
echo "Saving access ID to file..."
echo "$ACCESS_ID" > k8s_auth_access_id.txt

echo "Auth Method Access ID: $ACCESS_ID"
echo "Access ID saved to k8s_auth_access_id.txt"
echo "Setup complete!"