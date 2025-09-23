#!/usr/bin/env bash
set -euo pipefail

# Install Rust via rustup (interactive by default).
# For non-interactive: set RUSTUP_INIT_FLAGS like '-y --profile minimal'
# Example: RUSTUP_INIT_FLAGS='-y' ./install-rust.sh

RUSTUP_INIT_FLAGS="${RUSTUP_INIT_FLAGS:-""}"

if ! command -v curl >/dev/null 2>&1; then
  echo "Error: curl is required." >&2
  exit 1
fi

# shellcheck disable=SC2086
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh ${RUSTUP_INIT_FLAGS}

echo "If PATH was updated, you may need to start a new shell (or 'source $HOME/.cargo/env')."

