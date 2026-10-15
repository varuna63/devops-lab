#!/usr/bin/env bash
set -euo pipefail

echo "========================================================"
echo "  Cleaning up Exercise 02: Flask App Resources          "
echo "========================================================"

MANIFESTS_DIR="$(cd "$(dirname "$0")/../manifests" && pwd)"
kubectl delete -f "$MANIFESTS_DIR/flask-app-all.yaml" --ignore-not-found

echo "Cleanup completed successfully."
