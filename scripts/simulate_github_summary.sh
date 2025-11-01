#!/usr/bin/env bash
# zsh/bash-safe script to simulate writing to $GITHUB_STEP_SUMMARY
SUMMARY_FILE=${1:-./tmp_summary.txt}
LOG_FILE=${2:-./logs/shift_run.log}

mkdir -p "$(dirname "$SUMMARY_FILE")"

SUMMARY_LINE=$(grep '^SUMMARY:' "$LOG_FILE" | tail -n1 || true)
if [ -z "$SUMMARY_LINE" ]; then
  echo "**Shift summary:** (no summary found)" > "$SUMMARY_FILE"
  exit 0
fi
REQUESTED=$(echo "$SUMMARY_LINE" | sed -E 's/.*requested=([0-9]+).*/\1/')
BLUE=$(echo "$SUMMARY_LINE" | sed -E 's/.*blue=([0-9]+).*/\1/')
GREEN=$(echo "$SUMMARY_LINE" | sed -E 's/.*green=([0-9]+).*/\1/')

cat > "$SUMMARY_FILE" <<EOF
## Shift traffic summary

| requested | blue | green |
|---:|---:|---:|
| $REQUESTED | $BLUE | $GREEN |

#!/usr/bin/env bash
# zsh/bash-safe script to simulate writing to $GITHUB_STEP_SUMMARY
SUMMARY_FILE=${1:-./tmp_summary.txt}
LOG_FILE=${2:-./logs/shift_run.log}

mkdir -p "$(dirname "$SUMMARY_FILE")"

SUMMARY_LINE=$(grep '^SUMMARY:' "$LOG_FILE" | tail -n1 || true)
if [ -z "$SUMMARY_LINE" ]; then
  echo "**Shift summary:** (no summary found)" > "$SUMMARY_FILE"
  exit 0
fi
REQUESTED=$(echo "$SUMMARY_LINE" | sed -E 's/.*requested=([0-9]+).*/\1/')
BLUE=$(echo "$SUMMARY_LINE" | sed -E 's/.*blue=([0-9]+).*/\1/')
GREEN=$(echo "$SUMMARY_LINE" | sed -E 's/.*green=([0-9]+).*/\1/')

cat > "$SUMMARY_FILE" <<EOF
## Shift traffic summary

| requested | blue | green |
|---:|---:|---:|
| $REQUESTED | $BLUE | $GREEN |

Raw summary:
EOF

# Append the raw summary inside a code fence safely (avoid backticks in unquoted heredoc)
printf '``\n%s\n``\n' "$SUMMARY_LINE" >> "$SUMMARY_FILE"

echo "Wrote summary to $SUMMARY_FILE"
