#!/usr/bin/env bash
set -euo pipefail

# Determine script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/../../../secrets/ssh"
SSH_DIR="$HOME/.ssh"

# Ensure backup dir exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Error: $BACKUP_DIR does not exist."
    exit 1
fi

mkdir -p "$SSH_DIR"
cp -a "$BACKUP_DIR"/* "$SSH_DIR"/

chmod 700 "$SSH_DIR"
chmod 600 "$SSH_DIR"/config "$SSH_DIR"/id_* 2>/dev/null || true
chmod 644 "$SSH_DIR"/*.pub "$SSH_DIR"/known_hosts 2>/dev/null || true

echo "✔ SSH config installed from $BACKUP_DIR"
