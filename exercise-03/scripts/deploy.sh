#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Deploying Exercise 03: Flash Sale ReplicaSet Scaling    "
echo "=========================================================="

# Check if minikube is running
if ! minikube status >/dev/null 2>&1; then
    echo "[*] Minikube is not running. Starting single-node minikube..."
    minikube start --nodes=1
fi

APP_DIR="$(cd "$(dirname "$0")/../app" && pwd)"
MANIFESTS_DIR="$(cd "$(dirname "$0")/../manifests" && pwd)"

# Build Docker image directly inside Minikube
echo "[*] Building Docker image 'flashsale:1.0' inside Minikube..."
if command -v docker >/dev/null 2>&1; then
    eval $(minikube docker-env)
    docker build -t flashsale:1.0 "$APP_DIR"
else
    echo "[*] Docker CLI not found on host, using 'minikube image build'..."
    minikube image build -t flashsale:1.0 "$APP_DIR"
fi

# Apply ReplicaSet and Service
echo "[*] Applying ReplicaSet and Service manifests..."
kubectl apply -f "$MANIFESTS_DIR/flashsale-replicaset.yaml"

# Wait for pods
echo "[*] Waiting for 3 ReplicaSet pods to become ready..."
kubectl rollout status rs/flashsale-rs --timeout=60s || true
kubectl get pods -l app=flashsale -o wide

echo "=========================================================="
echo "  Initial 3 pods running. Ready to scale to 5!"
echo "  Run to scale:"
echo "    kubectl scale rs flashsale-rs --replicas=5"
echo "=========================================================="
