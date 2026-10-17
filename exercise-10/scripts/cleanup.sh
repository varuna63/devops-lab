#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE="devops-multinode"
kubectl --context="$PROFILE" delete -f "$ROOT/manifests/shopping-cart.yaml" --ignore-not-found=true
kubectl --context="$PROFILE" delete -f "$ROOT/manifests/product-catalog.yaml" --ignore-not-found=true

echo "Exercise resources deleted. The Minikube profile was retained."
echo "To also delete the cluster, run: minikube -p $PROFILE delete"
