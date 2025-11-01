#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "Building project..."
mvn -q -DskipTests package || true

echo "Starting instances"
./scripts/run-instances.sh
sleep 2

echo "Shifting 30% traffic to BLUE (100 requests)"
./scripts/shift_traffic.sh 30 100 | tee logs/smoke_shift.log

echo "Stopping instances"
./scripts/stop-instances.sh

echo "Smoke test complete. Summary from logs:"
tail -n 20 logs/smoke_shift.log || true
