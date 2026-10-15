#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Cleaning up Exercise 03: Flash Sale ReplicaSet          "
echo "=========================================================="

MANIFESTS_DIR="$(cd "$(dirname "$0")/../manifests" && pwd)"
kubectl delete -f "$MANIFESTS_DIR/flashsale-replicaset.yaml" --ignore-not-found
kubectl delete -f "$MANIFESTS_DIR/flashsale-deployment.yaml" --ignore-not-found

echo "Cleanup completed successfully."
