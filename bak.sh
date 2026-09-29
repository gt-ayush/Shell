#!/usr/bin/env bash

set -euo pipefail

SRC_DIR="${1:-/etc}"
DEST_DIR="${2:-/var/backups}"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
ARCHIVE_NAME="backup_$(basename "$SRC_DIR")_${TIMESTAMP}.tar.gz"

mkdir -p "$DEST_DIR"
echo "Creating archive $DEST_DIR/$ARCHIVE_NAME from $SRC_DIR..."
tar -czf "$DEST_DIR/$ARCHIVE_NAME" "$SRC_DIR"

echo "Archive created successfully ($(du -sh "$DEST_DIR/$ARCHIVE_NAME" | awk '{print $1}'))."

find "$DEST_DIR" -type f -name "backup_*.tar.gz" -mtime +30 -delete