#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  Deploying Exercise 01: Hello Pod (Zepto App)   "
echo "=================================================="

# Check if minikube is running, start if not
if ! minikube status >/dev/null 2>&1; then
    echo "[*] Minikube is not running. Starting minikube..."
    minikube start
fi

# Apply declarative manifests
echo "[*] Applying manifests..."
kubectl apply -f "$(dirname "$0")/../manifests/pod.yaml"
kubectl apply -f "$(dirname "$0")/../manifests/service.yaml"

# Wait for pod to be ready
echo "[*] Waiting for pod/hello-k8s to be ready..."
kubectl wait --for=condition=Ready pod/hello-k8s --timeout=60s

echo "[*] Verifying Pod and Service..."
kubectl get pod hello-k8s -o wide
kubectl get svc hello-k8s

echo "=================================================="
echo "  Deployment successful!"
echo "  Access the service using:"
echo "    minikube service hello-k8s"
echo "  Or via port-forwarding:"
echo "    kubectl port-forward pod/hello-k8s 8080:80"
echo "=================================================="
