#!/usr/bin/env bash
# Start BLUE and GREEN instances locally
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JAVA=$(command -v java || true)
if [ -z "$JAVA" ]; then
  echo "Java not found in PATH"
  exit 1
fi

cd "$ROOT"

echo "Building project..."
mvn -q -DskipTests package

echo "Starting BLUE (port 8081)"
DEPLOY_COLOR=BLUE VERSION=${BLUE_VERSION:-v2} PORT=8081 nohup java -cp target/classes com.example.bluegreen.App > logs/blue.log 2>&1 &
BLUE_PID=$!
echo $BLUE_PID > run/blue.pid

echo "Starting GREEN (port 8082)"
DEPLOY_COLOR=GREEN VERSION=${GREEN_VERSION:-v1} PORT=8082 nohup java -cp target/classes com.example.bluegreen.App > logs/green.log 2>&1 &
GREEN_PID=$!
echo $GREEN_PID > run/green.pid

echo "BLUE pid=$BLUE_PID GREEN pid=$GREEN_PID"
