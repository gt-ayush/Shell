#!/usr/bin/env bash

set -euo pipefail

read -s -p "Enter password to evaluate: " password
echo ""

if [[ ${#password} -lt 8 ]]; then
  echo "FAIL: Password must be at least 8 characters long."; exit 1
fi
if ! [[ "$password" =~ [A-Z] ]]; then
  echo "FAIL: Missing at least one uppercase letter (A-Z)."; exit 1
fi
if ! [[ "$password" =~ [a-z] ]]; then
  echo "FAIL: Missing at least one lowercase letter (a-z)."; exit 1
fi
if ! [[ "$password" =~ [0-9] ]]; then
  echo "FAIL: Missing at least one numeric digit (0-9)."; exit 1
fi
if ! [[ "$password" =~ ['!@#$%^&*()_+'] ]]; then
  echo "FAIL: Missing at least one special character (!@#$%^&*)."; exit 1
fi

echo "SUCCESS: Password satisfies all enterprise complexity requirements."