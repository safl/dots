#!/usr/bin/env bash
# Install Rust via rustup (non-interactive)
set -euo pipefail

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- ${RUSTUP_INIT_FLAGS:- -y}
