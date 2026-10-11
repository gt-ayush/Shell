calculate_disk_usage() {
  local target_dir="$1"

  if [[ ! -d "$target_dir" ]]; then
    echo "Error: Directory $target_dir does not exist." >&2
    return 1
  fi

  local usage
  usage=$(du -sh "$target_dir" | awk '{print $1}')
  echo "$usage"
  return 0
}

DIR_SIZE=$(calculate_disk_usage "/var/log")