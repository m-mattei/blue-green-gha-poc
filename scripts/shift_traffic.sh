#!/usr/bin/env bash
set -euo pipefail
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 PERCENT_TO_BLUE TOTAL_REQUESTS"
  echo "Example: $0 30 100 -> send 30% requests to BLUE, 70% to GREEN"
  exit 2
fi

PCT=$1
TOTAL=$2

if [ "$PCT" -lt 0 ] || [ "$PCT" -gt 100 ]; then
  echo "PERCENT_TO_BLUE must be 0-100"
  exit 2
fi

BLUE_URL=${BLUE_URL:-http://localhost:8081/}
GREEN_URL=${GREEN_URL:-http://localhost:8082/}

blue_count=0
green_count=0

for i in $(seq 1 $TOTAL); do
  r=$((RANDOM % 100))
  if [ $r -lt $PCT ]; then
    url=$BLUE_URL
    blue_count=$((blue_count+1))
  else
    url=$GREEN_URL
    green_count=$((green_count+1))
  fi
  # fire and forget but capture color from response
  resp=$(curl -sS --max-time 2 "$url" || echo "{\"error\":true}")
  echo "$i -> $url  -> $resp"
done

echo "SUMMARY: requested=$TOTAL blue=$blue_count green=$green_count"
