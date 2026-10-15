#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Deploying Exercise 04: Docker Multi-Container Network   "
echo "=========================================================="

APP_DIR="$(cd "$(dirname "$0")/../app" && pwd)"

# Task 1: Create custom bridge network if it doesn't already exist
if ! docker network ls | grep -qw "my-bridge-net"; then
    echo "[*] Task 1: Creating bridge network 'my-bridge-net'..."
    docker network create --driver bridge my-bridge-net
else
    echo "[*] Network 'my-bridge-net' already exists."
fi

# Task 2 & 3: Verify and Inspect network
echo "[*] Task 2: Verifying network..."
docker network ls | grep "my-bridge-net"

# Task 4: Build Flask image
echo "[*] Task 4: Building Flask Docker image 'flask-api'..."
docker build -t flask-api "$APP_DIR"

# Launch containers
echo "[*] Launching MySQL container..."
docker run -d --name mysql --net=my-bridge-net -e MYSQL_ROOT_PASSWORD=rootpassword mysql:latest

echo "[*] Launching Redis container..."
docker run -d --name redis --net=my-bridge-net redis:latest

echo "[*] Launching Flask container..."
docker run -d --name flask --net=my-bridge-net -p 5001:5001 flask-api

# Task 5: Test Connectivity
echo "[*] Task 5: Testing connectivity between containers..."
echo "--- Pinging MySQL from Flask container ---"
docker exec flask ping -c 3 mysql

echo "--- Pinging Redis from Flask container ---"
docker exec flask ping -c 3 redis

echo "--- Testing Flask HTTP endpoint from host ---"
curl -s http://localhost:5001/about || echo "Note: Check if port 5001 is mapped."

echo "=========================================================="
echo "  Deployment and connectivity verification complete!"
echo "=========================================================="
