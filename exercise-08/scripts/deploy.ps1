# PowerShell Helper Script for Exercise 08: Hello World Jenkins Freestyle Job
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Exercise 08: Hello World Jenkins Freestyle Job          " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Test local execution
Write-Host "[*] Verifying hello-world.ps1 locally..." -ForegroundColor Green
& "$scriptDir\hello-world.ps1"

# Check if Jenkins is up
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/json" -TimeoutSec 3 -UseBasicParsing -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "`n[+] Jenkins is running on http://localhost:8080." -ForegroundColor Green
        Write-Host "[*] You can configure the 'HelloWorld' job in the UI or use config.xml" -ForegroundColor White
    }
} catch {
    Write-Host "`n[i] Jenkins server is not currently running on port 8080." -ForegroundColor Gray
    Write-Host "[i] Follow the step-by-step instructions in exercise-08/README.md to launch and configure." -ForegroundColor Gray
}

Write-Host "==========================================================" -ForegroundColor Cyan
