#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Deploying Exercise 06: ZAPPTTO Delivery Monitoring     "
echo "=========================================================="

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MON_DIR="$SCRIPT_DIR/../delivery_monitoring"

# 1. Build and run Python Delivery Metrics service
echo "[*] Building and starting delivery_metrics container..."
docker build -t delivery_metrics "$MON_DIR"
docker stop delivery_metrics 2>/dev/null || true
docker rm delivery_metrics 2>/dev/null || true
docker run -d --name delivery_metrics -p 8000:8000 delivery_metrics

# 2. Run Prometheus with mounted configs
echo "[*] Starting Prometheus..."
docker stop prometheus 2>/dev/null || true
docker rm prometheus 2>/dev/null || true
docker run -d --name prometheus -p 9090:9090 \
    -v "$MON_DIR/prometheus.yml":/etc/prometheus/prometheus.yml:ro \
    -v "$MON_DIR/alert_rules.yml":/etc/prometheus/alert_rules.yml:ro \
    prom/prometheus

# 3. Run Grafana
echo "[*] Starting Grafana..."
docker stop grafana 2>/dev/null || true
docker rm grafana 2>/dev/null || true
docker run -d --name grafana -p 3000:3000 grafana/grafana

# 4. Run Jenkins
echo "[*] Starting Jenkins..."
docker stop jenkins 2>/dev/null || true
docker rm jenkins 2>/dev/null || true
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
    -v jenkins_home:/var/jenkins_home \
    jenkins/jenkins:lts

echo "=========================================================="
echo "  Services Deployed Successfully!"
echo "  • Metrics Endpoint:   http://localhost:8000/metrics"
echo "  • Prometheus Web UI:  http://localhost:9090"
echo "  • Grafana Dashboard:  http://localhost:3000 (admin/admin)"
echo "  • Jenkins CI Server:  http://localhost:8080"
echo "=========================================================="
