$ErrorActionPreference = "Continue"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Profile = "devops-multinode"
kubectl --context=$Profile delete -f (Join-Path $Root "manifests/shopping-cart.yaml") --ignore-not-found=true
kubectl --context=$Profile delete -f (Join-Path $Root "manifests/product-catalog.yaml") --ignore-not-found=true
Write-Host "Exercise resources deleted. The Minikube profile was retained."
Write-Host "To also delete the cluster, run: minikube -p $Profile delete"
