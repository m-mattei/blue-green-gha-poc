#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [ -f "$ROOT/run/blue.pid" ]; then
  kill "$(cat $ROOT/run/blue.pid)" || true
  rm -f "$ROOT/run/blue.pid"
  echo "Stopped BLUE"
fi
if [ -f "$ROOT/run/green.pid" ]; then
  kill "$(cat $ROOT/run/green.pid)" || true
  rm -f "$ROOT/run/green.pid"
  echo "Stopped GREEN"
fi
