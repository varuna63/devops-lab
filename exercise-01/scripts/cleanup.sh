#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  Cleaning up Exercise 01: Hello Pod Resources    "
echo "=================================================="

kubectl delete -f "$(dirname "$0")/../manifests/service.yaml" --ignore-not-found
kubectl delete -f "$(dirname "$0")/../manifests/pod.yaml" --ignore-not-found

echo "Cleanup completed successfully."
