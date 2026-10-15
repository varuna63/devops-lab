#!/usr/bin/env bash
set -euo pipefail

echo "========================================================"
echo "  Deploying Exercise 02: Flask App on Minikube          "
echo "========================================================"

# Check if minikube is running
if ! minikube status >/dev/null 2>&1; then
    echo "[*] Minikube is not running. Starting minikube..."
    minikube start
fi

APP_DIR="$(cd "$(dirname "$0")/../app" && pwd)"
MANIFESTS_DIR="$(cd "$(dirname "$0")/../manifests" && pwd)"

# Build Docker image directly inside Minikube
echo "[*] Building Docker image 'flask-app:latest' inside Minikube..."
if command -v docker >/dev/null 2>&1; then
    eval $(minikube docker-env)
    docker build -t flask-app:latest "$APP_DIR"
else
    # Fallback to minikube image build if host docker is unavailable
    echo "[*] Docker CLI not found on host, using 'minikube image build'..."
    minikube image build -t flask-app:latest "$APP_DIR"
fi

# Apply manifests
echo "[*] Applying Kubernetes deployment and service manifests..."
kubectl apply -f "$MANIFESTS_DIR/flask-app-all.yaml"

# Wait for rollout
echo "[*] Waiting for deployment rollout..."
kubectl rollout status deployment/flask-app --timeout=60s

# Display status
echo "[*] Verification:"
kubectl get deployment flask-app
kubectl get pods -l app=flask-app -o wide
kubectl get service flask-app-service

echo "========================================================"
echo "  Deployment successful!"
echo "  To obtain the service URL, run:"
echo "    minikube service flask-app-service --url"
echo "========================================================"
