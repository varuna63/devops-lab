# PowerShell Deploy Script for Exercise 02: Flask App on Minikube
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Deploying Exercise 02: Flask App on Minikube          " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Check if minikube is running
$status = minikube status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[*] Minikube is not running. Starting minikube..." -ForegroundColor Yellow
    minikube start
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$appDir = Resolve-Path "$scriptDir\..\app"
$manifestsDir = Resolve-Path "$scriptDir\..\manifests"

# Configure minikube docker-env in PowerShell or use minikube image build
Write-Host "[*] Building Docker image 'flask-app:latest' in Minikube..." -ForegroundColor Green
$dockerCmd = Get-Command docker -ErrorAction SilentlyContinue

if ($dockerCmd) {
    & minikube docker-env --shell powershell | Invoke-Expression
    docker build -t flask-app:latest "$appDir"
} else {
    Write-Host "[*] Docker CLI not in PATH, using 'minikube image build'..." -ForegroundColor Yellow
    minikube image build -t flask-app:latest "$appDir"
}

# Apply manifests
Write-Host "[*] Applying manifests..." -ForegroundColor Green
kubectl apply -f "$manifestsDir\flask-app-all.yaml"

# Wait for rollout
Write-Host "[*] Waiting for deployment rollout..." -ForegroundColor Yellow
kubectl rollout status deployment/flask-app --timeout=60s

Write-Host "[*] Verification:" -ForegroundColor Green
kubectl get deployment flask-app
kubectl get pods -l app=flask-app -o wide
kubectl get service flask-app-service

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Deployment successful!" -ForegroundColor Cyan
Write-Host "  To obtain the service URL, run:" -ForegroundColor Yellow
Write-Host "    minikube service flask-app-service --url" -ForegroundColor White
Write-Host "========================================================" -ForegroundColor Cyan
