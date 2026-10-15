# PowerShell Deploy Script for Exercise 05: Docker Security with AppArmor
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Deploying Exercise 05: Docker Security with AppArmor    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

Write-Host @"
[NOTE] AppArmor is a Linux Security Module (LSM) enforced by the Linux kernel.
When running on Windows with Docker Desktop (WSL2 backend), the AppArmor profile
must be loaded inside your WSL2 Linux distribution (e.g., Ubuntu).
"@ -ForegroundColor Yellow

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$appDir = Resolve-Path "$scriptDir\..\app"

# Build image
Write-Host "[*] Building Docker image 'flask-apparmor'..." -ForegroundColor Green
docker build -t flask-apparmor "$appDir"

Write-Host @"
To load the AppArmor profile in WSL / Linux, execute:
  sudo cp security/my-apparmor-profile /etc/apparmor.d/my-apparmor-profile
  sudo apparmor_parser -r /etc/apparmor.d/my-apparmor-profile

Then run with security option:
  docker run -d --name flask-apparmor --security-opt="apparmor=my-apparmor-profile" -p 5000:5000 flask-apparmor

Or run the Python SDK scripts:
  pip install -r python_sdk/requirements.txt
  python python_sdk/apply_apparmor.py
  python python_sdk/test_restricted_actions.py
"@ -ForegroundColor White
