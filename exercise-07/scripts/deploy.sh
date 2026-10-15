#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Deploying Exercise 07: Jenkins CI Installation          "
echo "=========================================================="

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Run Jenkins container
echo "[*] Launching Jenkins LTS container..."
docker run -d --name jenkins-ci \
    -p 8080:8080 \
    -p 50000:50000 \
    -v jenkins_home:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    jenkins/jenkins:lts

echo "[*] Waiting for Jenkins to initialize and generate admin password (approx 20-30s)..."
for i in {1..30}; do
    if docker exec jenkins-ci test -f /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null; then
        echo -e "\n[+] Jenkins initialized!"
        break
    fi
    echo -n "."
    sleep 2
done

echo ""
"$SCRIPT_DIR/get_admin_password.sh" "jenkins-ci"
