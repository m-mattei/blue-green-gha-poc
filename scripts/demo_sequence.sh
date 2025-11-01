#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [ $# -lt 1 ]; then
  echo "Usage: $0 P1 [P2 P3 ...]"
  echo "Example: $0 10 30 60"
  exit 2
fi

mkdir -p logs

echo "Starting BLUE and GREEN instances with BLUE initial traffic 0%"
./scripts/run-instances.sh
sleep 2

summary_file=logs/demo_sequence_summary.txt
echo "demo-started-at: $(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$summary_file"
echo "initial_blue_traffic: 0" >> "$summary_file"

count=0
for p in "$@"; do
  count=$((count+1))
  echo "--- Shift #$count: setting BLUE traffic to ${p}% ---"
  echo "shift_${count}_to_blue: ${p}" >> "$summary_file"
  ./scripts/shift_traffic.sh "$p" 100 > "logs/demo_shift_${count}.log" || true
  # capture summary
  tail -n 1 "logs/demo_shift_${count}.log" >> "$summary_file" || true
  echo "Wrote logs/demo_shift_${count}.log"
  sleep 1
done

echo "Finalizing deployment: routing 100% to BLUE and stopping GREEN"
echo "finalize_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$summary_file"
./scripts/stop-instances.sh

echo "Demo sequence complete. Summary:"
cat "$summary_file"
echo "Logs:"
ls -1 logs/demo_shift_*.log || true
