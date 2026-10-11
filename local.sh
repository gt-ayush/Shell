calculate() {
  local a="$1"
  local b="$2"
  local result=$((a + b))

  echo "$result"
}

calculate 10 20