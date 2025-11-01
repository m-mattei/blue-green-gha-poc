#!/usr/bin/env bash
set -euo pipefail

echo "Running GH Actions demo steps locally (simulated)"
chmod +x scripts/*.sh
mvn -B -DskipTests package || true
./scripts/run-instances.sh
./scripts/shift_traffic.sh ${1:-30} 100 > logs/gha_demo_shift.log || true
./scripts/stop-instances.sh || true
echo "Logs available at logs/gha_demo_shift.log"
