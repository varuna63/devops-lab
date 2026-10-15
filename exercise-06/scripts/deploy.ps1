# PowerShell Deploy Script for Exercise 06: ZAPPTTO Delivery Monitoring
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Deploying Exercise 06: ZAPPTTO Delivery Monitoring     " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$monDir = Resolve-Path "$scriptDir\..\delivery_monitoring"

# 1. Build and run delivery_metrics
Write-Host "[*] Building and starting delivery_metrics container..." -ForegroundColor Green
docker build -t delivery_metrics "$monDir"
docker stop delivery_metrics 2>$null
docker rm delivery_metrics 2>$null
docker run -d --name delivery_metrics -p 8000:8000 delivery_metrics

# 2. Start Prometheus
Write-Host "[*] Starting Prometheus..." -ForegroundColor Green
docker stop prometheus 2>$null
docker rm prometheus 2>$null
docker run -d --name prometheus -p 9090:9090 `
    -v "${monDir}\prometheus.yml:/etc/prometheus/prometheus.yml:ro" `
    -v "${monDir}\alert_rules.yml:/etc/prometheus/alert_rules.yml:ro" `
    prom/prometheus

# 3. Start Grafana
Write-Host "[*] Starting Grafana..." -ForegroundColor Green
docker stop grafana 2>$null
docker rm grafana 2>$null
docker run -d --name grafana -p 3000:3000 grafana/grafana

# 4. Start Jenkins
Write-Host "[*] Starting Jenkins..." -ForegroundColor Green
docker stop jenkins 2>$null
docker rm jenkins 2>$null
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Services Deployed Successfully!" -ForegroundColor Cyan
Write-Host "  • Metrics Endpoint:   http://localhost:8000/metrics" -ForegroundColor Yellow
Write-Host "  • Prometheus Web UI:  http://localhost:9090" -ForegroundColor Yellow
Write-Host "  • Grafana Dashboard:  http://localhost:3000 (admin/admin)" -ForegroundColor Yellow
Write-Host "  • Jenkins CI Server:  http://localhost:8080" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
