#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE="devops-multinode"

for cmd in docker minikube kubectl; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "ERROR: $cmd is required." >&2; exit 1; }
done

if ! minikube -p "$PROFILE" status >/dev/null 2>&1; then
  minikube start --nodes=3 -p "$PROFILE"
fi

minikube -p "$PROFILE" status
docker build -t product-catalog:latest -f "$ROOT/app/Dockerfile.product" "$ROOT/app"
docker build -t shopping-cart:latest -f "$ROOT/app/Dockerfile.shopping" "$ROOT/app"
minikube -p "$PROFILE" image load product-catalog:latest
minikube -p "$PROFILE" image load shopping-cart:latest
kubectl --context="$PROFILE" apply -f "$ROOT/manifests/product-catalog.yaml"
kubectl --context="$PROFILE" apply -f "$ROOT/manifests/shopping-cart.yaml"
kubectl --context="$PROFILE" rollout status deployment/product-catalog --timeout=180s
kubectl --context="$PROFILE" rollout status deployment/shopping-cart --timeout=180s
kubectl --context="$PROFILE" get nodes
kubectl --context="$PROFILE" get pods -o wide
kubectl --context="$PROFILE" get services
