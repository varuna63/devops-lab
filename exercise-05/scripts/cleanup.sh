#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Cleaning up Exercise 05: Docker Security with AppArmor  "
echo "=========================================================="

echo "[*] Stopping and removing containers..."
docker stop flask-apparmor flask-apparmor-demo flask-apparmor-test 2>/dev/null || true
docker rm flask-apparmor flask-apparmor-demo flask-apparmor-test 2>/dev/null || true

# Optionally remove profile from AppArmor kernel
if [ -f /etc/apparmor.d/my-apparmor-profile ] && command -v apparmor_parser >/dev/null 2>&1; then
    echo "[*] Unloading profile from AppArmor..."
    sudo apparmor_parser -R /etc/apparmor.d/my-apparmor-profile 2>/dev/null || true
    sudo rm -f /etc/apparmor.d/my-apparmor-profile 2>/dev/null || true
fi

echo "Cleanup completed successfully."
