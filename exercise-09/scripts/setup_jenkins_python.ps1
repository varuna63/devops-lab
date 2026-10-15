param(
    [string]$Container = "jenkins-ci"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Setting up Python3 in Jenkins Container: $Container     " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$running = docker ps --format '{{.Names}}'
if ($running -notcontains $Container -and $running -contains "jenkins") {
    $Container = "jenkins"
}

Write-Host "[*] Installing python3, pip, venv, and flask in container as root..." -ForegroundColor Green
docker exec -u root $Container bash -c "apt-get update && apt-get install -y python3 python3-pip python3-venv python3-flask curl"

Write-Host "[*] Verifying python3 inside Jenkins:" -ForegroundColor Green
docker exec $Container python3 --version
docker exec $Container python3 -m pip --version
Write-Host "==========================================================" -ForegroundColor Cyan
