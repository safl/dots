#!/usr/bin/env bash
set -euo pipefail

# Install or update Helix config from ./helix.
# Usage: ./install-helix.sh
# Customize source via HELIX_SRC=/path/to/helix (defaults to $PWD/helix)

HELIX_SRC="${HELIX_SRC:-"$(pwd)/../home/helix"}"
CONFIG_DIR="${HOME}/.config"
TARGET_DIR="${CONFIG_DIR}/helix"

mkdir -p "${CONFIG_DIR}"

if [[ ! -d "${HELIX_SRC}" ]]; then
  echo "Error: 'helix' directory not found at '${HELIX_SRC}'." >&2
  exit 1
fi

if [[ -d "${TARGET_DIR}" ]]; then
  echo "Updating existing Helix config in '${TARGET_DIR}'..."
  cp -r "${HELIX_SRC}/." "${TARGET_DIR}/"
else
  echo "Installing new Helix config to '${TARGET_DIR}'..."
  cp -r "${HELIX_SRC}" "${TARGET_DIR}"
fi

echo "Helix config installed."

