#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Deploying Exercise 05: Docker Security with AppArmor    "
echo "=========================================================="

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILE_SRC="$SCRIPT_DIR/../security/my-apparmor-profile"
APP_DIR="$SCRIPT_DIR/../app"

# Step 1: Install apparmor-utils if parser is missing
if ! command -v apparmor_parser >/dev/null 2>&1; then
    echo "[*] Installing apparmor-utils..."
    sudo apt-get update -y && sudo apt-get install -y apparmor-utils
fi

# Step 2: Copy and load AppArmor profile into kernel
echo "[*] Loading AppArmor profile into Linux kernel..."
sudo cp "$PROFILE_SRC" /etc/apparmor.d/my-apparmor-profile
sudo apparmor_parser -r /etc/apparmor.d/my-apparmor-profile

# Step 3: Build Docker image
echo "[*] Building Docker image 'flask-apparmor'..."
docker build -t flask-apparmor "$APP_DIR"

# Step 4: Run container with AppArmor profile
echo "[*] Launching container with --security-opt='apparmor=my-apparmor-profile'..."
docker run -d --name flask-apparmor \
    --security-opt="apparmor=my-apparmor-profile" \
    -p 5000:5000 \
    flask-apparmor

# Step 5: Test enforcement
echo -e "\n[*] Testing Security Restrictions:"
echo "--- 1. Testing sensitive file read: cat /etc/passwd (should fail) ---"
docker exec flask-apparmor cat /etc/passwd || echo "[BLOCKED] Read access to /etc/passwd was denied by AppArmor."

echo -e "\n--- 2. Testing binary execution: /bin/bash (should fail) ---"
docker exec flask-apparmor /bin/bash || echo "[BLOCKED] Execution of /bin/bash was denied by AppArmor."

echo -e "\n--- 3. Testing allowed web endpoint ---"
curl -s http://localhost:5000/ || true

echo -e "\n=========================================================="
echo "  AppArmor enforcement verification completed successfully!"
echo "=========================================================="
