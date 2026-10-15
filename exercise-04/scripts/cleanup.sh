#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Cleaning up Exercise 04: Docker Multi-Container Network "
echo "=========================================================="

echo "[*] Stopping and removing containers: mysql, redis, flask..."
docker stop mysql redis flask 2>/dev/null || true
docker rm mysql redis flask 2>/dev/null || true

echo "[*] Removing network 'my-bridge-net'..."
docker network rm my-bridge-net 2>/dev/null || true

echo "Cleanup completed successfully."
