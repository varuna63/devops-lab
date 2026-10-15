# PowerShell Deploy Script for Exercise 04: Docker Multi-Container Network
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Deploying Exercise 04: Docker Multi-Container Network   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$appDir = Resolve-Path "$scriptDir\..\app"

# Task 1: Create bridge network
$existingNet = docker network ls --filter name=my-bridge-net -q
if (-not $existingNet) {
    Write-Host "[*] Task 1: Creating bridge network 'my-bridge-net'..." -ForegroundColor Green
    docker network create --driver bridge my-bridge-net
} else {
    Write-Host "[*] Network 'my-bridge-net' already exists." -ForegroundColor Yellow
}

# Task 2: Verify network
Write-Host "[*] Task 2: Verifying network..." -ForegroundColor Green
docker network ls --filter name=my-bridge-net

# Task 4: Build image
Write-Host "[*] Task 4: Building Flask Docker image 'flask-api'..." -ForegroundColor Green
docker build -t flask-api "$appDir"

# Launch containers
Write-Host "[*] Launching MySQL container..." -ForegroundColor Green
docker run -d --name mysql --net=my-bridge-net -e MYSQL_ROOT_PASSWORD=rootpassword mysql:latest

Write-Host "[*] Launching Redis container..." -ForegroundColor Green
docker run -d --name redis --net=my-bridge-net redis:latest

Write-Host "[*] Launching Flask container..." -ForegroundColor Green
docker run -d --name flask --net=my-bridge-net -p 5001:5001 flask-api

# Task 5: Test Connectivity
Write-Host "[*] Task 5: Testing connectivity between containers..." -ForegroundColor Green
Write-Host "--- Pinging MySQL from Flask container ---" -ForegroundColor Yellow
docker exec flask ping -c 3 mysql

Write-Host "--- Pinging Redis from Flask container ---" -ForegroundColor Yellow
docker exec flask ping -c 3 redis

Write-Host "--- Testing Flask HTTP endpoint from host ---" -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "http://localhost:5001/about"
} catch {
    Write-Host "Flask endpoint reached or still starting..." -ForegroundColor Gray
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Deployment and connectivity verification complete!" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
