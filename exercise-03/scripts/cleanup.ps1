# PowerShell Cleanup Script for Exercise 03: Flash Sale ReplicaSet
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Cleaning up Exercise 03: Flash Sale ReplicaSet          " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifestsDir = Resolve-Path "$scriptDir\..\manifests"

kubectl delete -f "$manifestsDir\flashsale-replicaset.yaml" --ignore-not-found
kubectl delete -f "$manifestsDir\flashsale-deployment.yaml" --ignore-not-found

Write-Host "Cleanup completed successfully." -ForegroundColor Green
