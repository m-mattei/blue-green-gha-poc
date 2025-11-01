#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/run"
if [ -f "$ROOT/run/blue.pid" ]; then
  BLUE_PID=$(cat "$ROOT/run/blue.pid" | tr -d '\n' || true)
  if [ -n "$BLUE_PID" ]; then
    kill "$BLUE_PID" || true
  fi
  rm -f "$ROOT/run/blue.pid"
  echo "Stopped BLUE"
fi
if [ -f "$ROOT/run/green.pid" ]; then
  GREEN_PID=$(cat "$ROOT/run/green.pid" | tr -d '\n' || true)
  if [ -n "$GREEN_PID" ]; then
    kill "$GREEN_PID" || true
  fi
  rm -f "$ROOT/run/green.pid"
  echo "Stopped GREEN"
fi
