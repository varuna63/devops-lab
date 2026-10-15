#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Cleaning up Exercise 06: ZAPPTTO Delivery Monitoring    "
echo "=========================================================="

echo "[*] Stopping and removing containers: delivery_metrics, prometheus, grafana, jenkins..."
docker stop delivery_metrics prometheus grafana jenkins 2>/dev/null || true
docker rm delivery_metrics prometheus grafana jenkins 2>/dev/null || true

echo "Cleanup completed successfully."
