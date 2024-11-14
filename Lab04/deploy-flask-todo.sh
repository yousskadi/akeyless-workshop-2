#!/bin/bash

# Script configuration
akeyless configure --profile default --access-id "$(jq -r .access_id creds_api_key_auth.json)" --access-key "$(jq -r .access_key creds_api_key_auth.json)"

APP_NAME="flask-todo"
NAMESPACE="flask-todo"
DB_NAME="todos"
DYNAMIC_SECRET_TTL="15s"
AKEYLESS_MYSQL_SECRET_NAME="/Workshops/mysql_root_password"
ARGOCD_SERVER="localhost:3000"  # ArgoCD server port-forwarded to 3000
ARGOCD_USER="admin"
ARGOCD_PASS=$(kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 --decode)
# Get repository information from git
REPO_URL=$(git config --get remote.origin.url)
REPO_NAME=$(echo $REPO_URL | grep -o 'github.com[:/][^.]*' | sed 's#github.com[:/]##')
GITHUB_USERNAME=$(echo $REPO_NAME | cut -d'/' -f1)
REPO_URL="https://github.com/${REPO_NAME}.git"

# Get Codespace name and construct Akeyless Gateway URL
CODESPACE_NAME=$(gh codespace list --json name,repository -q ".[] | select(.repository==\"${REPO_NAME}\") | .name")
if [ -z "$CODESPACE_NAME" ]; then
    echo "Error: Could not find codespace for repository ${REPO_NAME}"
    exit 1
fi

CODESPACE_DOMAIN="app.github.dev"
AKEYLESS_GATEWAY_URL="https://${CODESPACE_NAME}-8080.${CODESPACE_DOMAIN}"
export AKEYLESS_GATEWAY_URL=$AKEYLESS_GATEWAY_URL

# Get MySQL root password from Akeyless
echo "Fetching MySQL root password..."
SECRET_JSON=$(akeyless get-secret-value --name "$AKEYLESS_MYSQL_SECRET_NAME")
if ! MYSQL_ROOT_PASSWORD=$(echo "$SECRET_JSON" | jq -r .password); then
    MYSQL_ROOT_PASSWORD="$SECRET_JSON"
fi

# Create namespace
echo "Creating namespace..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Create MySQL root password secret
echo "Creating MySQL root password secret..."
kubectl create secret generic mysql-root-secret \
    --from-literal=mysql-root-password="$MYSQL_ROOT_PASSWORD" \
    --namespace=$NAMESPACE \
    --dry-run=client -o yaml | kubectl apply -f -

# Login to ArgoCD
echo "Logging into ArgoCD..."
argocd login $ARGOCD_SERVER --username $ARGOCD_USER --password $ARGOCD_PASS --grpc-web --insecure

# Create ArgoCD application
echo "Creating ArgoCD application..."
argocd app create $APP_NAME \
    --repo $REPO_URL \
    --path k8s-manifests \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace $NAMESPACE \
    --project default \
    --sync-policy automated \
    --sync-option CreateNamespace=true \
    --upsert

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql-$APP_NAME -n $NAMESPACE --timeout=300s

# Create Akeyless target
echo "Creating Akeyless target..."
akeyless target create db \
    --name "/Workshops/Workshop2/${GITHUB_USERNAME}/mysql_password_target" \
    --db-type mysql \
    --pwd "$MYSQL_ROOT_PASSWORD" \
    --host "mysql-${APP_NAME}.${NAMESPACE}.svc.cluster.local" \
    --port 3306 \
    --user-name "root" \
    --db-name "$DB_NAME" || true  # Continue if target already exists

# Create Akeyless dynamic secret
echo "Creating Akeyless dynamic secret..."
export AKEYLESS_GATEWAY_URL=$AKEYLESS_GATEWAY_URL
akeyless dynamic-secret create mysql \
    --name "/Workshops/Workshop2/${GITHUB_USERNAME}/mysql_password_dynamic" \
    --target-name "/Workshops/Workshop2/${GITHUB_USERNAME}/mysql_password_target" \
    --gateway-url "${AKEYLESS_GATEWAY_URL}" \
    --user-ttl "${DYNAMIC_SECRET_TTL}" \
    --mysql-statements "CREATE USER '{{name}}'@'%' IDENTIFIED WITH mysql_native_password BY '{{password}}' PASSWORD EXPIRE INTERVAL 30 DAY;GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '{{name}}'@'%';" \
    --mysql-revocation-statements "REVOKE ALL PRIVILEGES, GRANT OPTION FROM '{{name}}'@'%'; DROP USER '{{name}}'@'%';" \
    --password-length 16 || true  # Continue if dynamic secret already exists

# Trigger ArgoCD sync
echo "Triggering ArgoCD sync..."
argocd app sync $APP_NAME

echo "Deployment completed successfully!"