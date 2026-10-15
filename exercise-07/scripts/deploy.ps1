# PowerShell Deploy Script for Exercise 07: Jenkins CI Installation
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Deploying Exercise 07: Jenkins CI Installation          " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Run Jenkins container
Write-Host "[*] Launching Jenkins LTS container..." -ForegroundColor Green
docker run -d --name jenkins-ci `
    -p 8080:8080 `
    -p 50000:50000 `
    -v jenkins_home:/var/jenkins_home `
    -v /var/run/docker.sock:/var/run/docker.sock `
    jenkins/jenkins:lts

Write-Host "[*] Waiting for Jenkins to generate admin password..." -ForegroundColor Yellow
for ($i = 0; $i -lt 30; $i++) {
    $hasSecret = docker exec jenkins-ci test -f /var/jenkins_home/secrets/initialAdminPassword 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n[+] Jenkins initialized!" -ForegroundColor Green
        break
    }
    Write-Host -NoNewline "."
    Start-Sleep -Seconds 2
}

& "$scriptDir\get_admin_password.ps1" -ContainerName "jenkins-ci"
