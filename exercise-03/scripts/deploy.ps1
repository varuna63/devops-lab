# PowerShell Deploy Script for Exercise 03: Flash Sale ReplicaSet Scaling
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Deploying Exercise 03: Flash Sale ReplicaSet Scaling    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Check if minikube is running
$status = minikube status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[*] Minikube is not running. Starting single-node minikube..." -ForegroundColor Yellow
    minikube start --nodes=1
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$appDir = Resolve-Path "$scriptDir\..\app"
$manifestsDir = Resolve-Path "$scriptDir\..\manifests"

# Build image
Write-Host "[*] Building Docker image 'flashsale:1.0' in Minikube..." -ForegroundColor Green
$dockerCmd = Get-Command docker -ErrorAction SilentlyContinue

if ($dockerCmd) {
    & minikube docker-env --shell powershell | Invoke-Expression
    docker build -t flashsale:1.0 "$appDir"
} else {
    Write-Host "[*] Docker CLI not in PATH, using 'minikube image build'..." -ForegroundColor Yellow
    minikube image build -t flashsale:1.0 "$appDir"
}

# Apply manifests
Write-Host "[*] Applying ReplicaSet and Service manifests..." -ForegroundColor Green
kubectl apply -f "$manifestsDir\flashsale-replicaset.yaml"

# Display pods
Write-Host "[*] Checking pods..." -ForegroundColor Green
Start-Sleep -Seconds 3
kubectl get rs flashsale-rs
kubectl get pods -l app=flashsale -o wide

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Initial 3 pods running. Ready to scale to 5!" -ForegroundColor Cyan
Write-Host "  Run to scale:" -ForegroundColor Yellow
Write-Host "    kubectl scale rs flashsale-rs --replicas=5" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
