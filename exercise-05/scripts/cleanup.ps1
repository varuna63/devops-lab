# PowerShell Cleanup Script for Exercise 05: Docker Security with AppArmor
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Cleaning up Exercise 05: Docker Security with AppArmor  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

Write-Host "[*] Stopping and removing test containers..." -ForegroundColor Yellow
docker stop flask-apparmor flask-apparmor-demo flask-apparmor-test 2>$null
docker rm flask-apparmor flask-apparmor-demo flask-apparmor-test 2>$null

Write-Host "Cleanup completed successfully." -ForegroundColor Green
