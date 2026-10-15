# PowerShell Cleanup Script for Exercise 07: Jenkins CI Container
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Cleaning up Exercise 07: Jenkins CI Container           " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

docker stop jenkins-ci jenkins 2>$null
docker rm jenkins-ci jenkins 2>$null

Write-Host "Cleanup completed successfully." -ForegroundColor Green
