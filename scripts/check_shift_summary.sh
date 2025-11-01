#!/usr/bin/env bash
set -euo pipefail

if [ -f logs/smoke_shift.log ]; then
  echo "Found smoke_shift.log"
  tail -n 5 logs/smoke_shift.log
  exit 0
else
  echo "logs/smoke_shift.log not found"
  exit 2
fi
