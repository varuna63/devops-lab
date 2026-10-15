#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Exercise 08: Hello World Jenkins Freestyle Job          "
echo "=========================================================="

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
JOB_XML="$SCRIPT_DIR/../job_config/config.xml"

# Test local execution
echo "[*] Verifying hello-world.sh locally..."
chmod +x "$SCRIPT_DIR/hello-world.sh"
bash "$SCRIPT_DIR/hello-world.sh"

# If Jenkins is running, attempt to create and trigger the job
if curl -s -f http://localhost:8080/api/json >/dev/null 2>&1; then
    echo -e "\n[*] Jenkins is accessible on http://localhost:8080."
    echo "[*] Creating/Updating 'HelloWorld' Freestyle job in Jenkins..."
    curl -s -X POST "http://localhost:8080/createItem?name=HelloWorld" \
        --data-binary @"$JOB_XML" \
        -H "Content-Type:text/xml" || echo "Job might already exist."
        
    echo "[*] Triggering build for HelloWorld..."
    curl -s -X POST "http://localhost:8080/job/HelloWorld/build" || true
    echo "[+] Build triggered! Visit http://localhost:8080/job/HelloWorld/ to view console output."
else
    echo -e "\n[i] Jenkins server is not detected on http://localhost:8080."
    echo "[i] Follow the step-by-step instructions in exercise-08/README.md to configure via the Web UI."
fi

echo "=========================================================="
