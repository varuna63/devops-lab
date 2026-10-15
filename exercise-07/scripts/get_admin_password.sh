#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="${1:-jenkins-ci}"

echo "=========================================================="
echo "  Retrieving Jenkins Initial Admin Password               "
echo "=========================================================="

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -qw "$CONTAINER_NAME"; then
    echo "[!] Container '$CONTAINER_NAME' is not running."
    echo "[*] Available running containers:"
    docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'
    exit 1
fi

echo "[*] Jenkins Admin Password:"
docker exec "$CONTAINER_NAME" cat /var/jenkins_home/secrets/initialAdminPassword
echo "=========================================================="
echo "  Copy the password above and paste it at http://localhost:8080"
echo "=========================================================="
