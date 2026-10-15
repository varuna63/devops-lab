#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Cleaning up Exercise 07: Jenkins CI Container           "
echo "=========================================================="

docker stop jenkins-ci jenkins 2>/dev/null || true
docker rm jenkins-ci jenkins 2>/dev/null || true

echo "Cleanup completed successfully."
