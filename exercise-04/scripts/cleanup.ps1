# PowerShell Cleanup Script for Exercise 04: Docker Multi-Container Network
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Cleaning up Exercise 04: Docker Multi-Container Network " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

Write-Host "[*] Stopping and removing containers: mysql, redis, flask..." -ForegroundColor Yellow
docker stop mysql redis flask 2>$null
docker rm mysql redis flask 2>$null

Write-Host "[*] Removing network 'my-bridge-net'..." -ForegroundColor Yellow
docker network rm my-bridge-net 2>$null

Write-Host "Cleanup completed successfully." -ForegroundColor Green
