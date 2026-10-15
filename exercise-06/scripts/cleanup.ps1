# PowerShell Cleanup Script for Exercise 06: ZAPPTTO Delivery Monitoring
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Cleaning up Exercise 06: ZAPPTTO Delivery Monitoring    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

Write-Host "[*] Stopping and removing containers..." -ForegroundColor Yellow
docker stop delivery_metrics prometheus grafana jenkins 2>$null
docker rm delivery_metrics prometheus grafana jenkins 2>$null

Write-Host "Cleanup completed successfully." -ForegroundColor Green
