# PowerShell Cleanup Script for Exercise 02: Flask App on Minikube
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Cleaning up Exercise 02: Flask App Resources          " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifestsDir = Resolve-Path "$scriptDir\..\manifests"

kubectl delete -f "$manifestsDir\flask-app-all.yaml" --ignore-not-found

Write-Host "Cleanup completed successfully." -ForegroundColor Green
