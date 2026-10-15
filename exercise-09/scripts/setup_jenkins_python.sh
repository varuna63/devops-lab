#!/usr/bin/env bash
set -euo pipefail

CONTAINER="${1:-jenkins-ci}"

echo "=========================================================="
echo "  Setting up Python3 in Jenkins Container: $CONTAINER     "
echo "=========================================================="

# Check container running
if ! docker ps --format '{{.Names}}' | grep -qw "$CONTAINER"; then
    echo "[!] Container '$CONTAINER' not found running. Checking 'jenkins'..."
    CONTAINER="jenkins"
fi

echo "[*] Installing python3, pip, venv, and flask in container as root..."
docker exec -u root "$CONTAINER" bash -c "
    apt-get update && \
    apt-get install -y python3 python3-pip python3-venv python3-flask curl && \
    echo '[+] Python installation complete inside Jenkins container!'
"

echo "[*] Verifying python3 inside Jenkins:"
docker exec "$CONTAINER" python3 --version
docker exec "$CONTAINER" python3 -m pip --version
echo "=========================================================="
