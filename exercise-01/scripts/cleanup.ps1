# PowerShell Cleanup Script for Exercise 01: Hello Pod
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Cleaning up Exercise 01: Hello Pod Resources    " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

kubectl delete -f "$scriptDir\..\manifests\service.yaml" --ignore-not-found
kubectl delete -f "$scriptDir\..\manifests\pod.yaml" --ignore-not-found

Write-Host "Cleanup completed successfully." -ForegroundColor Green
