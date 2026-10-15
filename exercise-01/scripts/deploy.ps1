# PowerShell Deploy Script for Exercise 01: Hello Pod
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Deploying Exercise 01: Hello Pod (Zepto App)   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Check if minikube is running
$status = minikube status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[*] Minikube is not running. Starting minikube..." -ForegroundColor Yellow
    minikube start
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Apply manifests
Write-Host "[*] Applying manifests..." -ForegroundColor Green
kubectl apply -f "$scriptDir\..\manifests\pod.yaml"
kubectl apply -f "$scriptDir\..\manifests\service.yaml"

# Wait for pod
Write-Host "[*] Waiting for pod/hello-k8s to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=Ready pod/hello-k8s --timeout=60s

Write-Host "[*] Verifying Pod and Service..." -ForegroundColor Green
kubectl get pod hello-k8s -o wide
kubectl get svc hello-k8s

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Deployment successful!" -ForegroundColor Cyan
Write-Host "  Access the service using:" -ForegroundColor Yellow
Write-Host "    minikube service hello-k8s" -ForegroundColor White
Write-Host "  Or via port-forwarding:" -ForegroundColor Yellow
Write-Host "    kubectl port-forward pod/hello-k8s 8080:80" -ForegroundColor White
Write-Host "==================================================" -ForegroundColor Cyan
