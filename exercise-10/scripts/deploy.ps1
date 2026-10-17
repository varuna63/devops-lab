$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Profile = "devops-multinode"

foreach ($cmd in @("docker", "minikube", "kubectl")) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        throw "$cmd is required. Install it and retry."
    }
}

minikube -p $Profile status 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    minikube start --nodes=3 -p $Profile
    if ($LASTEXITCODE -ne 0) { throw "Minikube failed to start." }
}

docker build -t product-catalog:latest -f (Join-Path $Root "app/Dockerfile.product") (Join-Path $Root "app")
if ($LASTEXITCODE -ne 0) { throw "Product Catalog image build failed." }
docker build -t shopping-cart:latest -f (Join-Path $Root "app/Dockerfile.shopping") (Join-Path $Root "app")
if ($LASTEXITCODE -ne 0) { throw "Shopping Cart image build failed." }
minikube -p $Profile image load product-catalog:latest
if ($LASTEXITCODE -ne 0) { throw "Product Catalog image load failed." }
minikube -p $Profile image load shopping-cart:latest
if ($LASTEXITCODE -ne 0) { throw "Shopping Cart image load failed." }

kubectl --context=$Profile apply -f (Join-Path $Root "manifests/product-catalog.yaml")
if ($LASTEXITCODE -ne 0) { throw "Product Catalog manifest failed." }
kubectl --context=$Profile apply -f (Join-Path $Root "manifests/shopping-cart.yaml")
if ($LASTEXITCODE -ne 0) { throw "Shopping Cart manifest failed." }
kubectl --context=$Profile rollout status deployment/product-catalog --timeout=180s
if ($LASTEXITCODE -ne 0) { throw "Product Catalog rollout failed." }
kubectl --context=$Profile rollout status deployment/shopping-cart --timeout=180s
if ($LASTEXITCODE -ne 0) { throw "Shopping Cart rollout failed." }
kubectl --context=$Profile get nodes
kubectl --context=$Profile get pods -o wide
kubectl --context=$Profile get services
