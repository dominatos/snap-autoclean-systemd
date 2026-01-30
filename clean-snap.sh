#!/bin/bash
# Non-interactive snap cleanup for systemd timer/service
# Removes disabled revisions, clears cache, reports space freed

set -euo pipefail

USED_BEFORE=$(df -k / | awk 'NR>1 {print $3}')

if command -v snap >/dev/null 2>&1; then
  echo "Starting snap cleanup..."
  snap set system refresh.retain=2
  snap list --all | awk '/disabled/{print $1, $3}' | while read -r snapname revision; do
    if [ -n "$snapname" ] && [ -n "$revision" ]; then
      echo "Removing $snapname revision $revision..."
      snap remove "$snapname" --revision="$revision" || true
    fi
  done
  if [ -d /var/lib/snapd/cache ]; then
    rm -rf /var/lib/snapd/cache/* 2>/dev/null || true
    echo "Cache cleared."
  fi
  echo "Snap cleanup completed."
else
  echo "Snap not installed/skipped."
fi

USED_AFTER=$(df -k / | awk 'NR>1 {print $3}')
FREED_MB=$(( (USED_BEFORE - USED_AFTER) / 1024 ))
echo "Freed space: ${FREED_MB} MB"
