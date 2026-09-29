#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="${1:-/var/log/nginx/access.log}"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Error: Log file '$LOG_FILE' not found."; exit 1
fi

echo "=== Top 5 Client IP Addresses ==="
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5

echo ""
echo "=== HTTP Status Code Breakdown ==="
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr