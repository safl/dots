#!/usr/bin/env bash
set -euo pipefail

# Configure global git identity.
# Usage: ./install-git.sh
# Customize via env: GIT_NAME="Your Name" GIT_EMAIL="you@example.com" ./install-git.sh

GIT_EMAIL="${GIT_EMAIL:-"os@safl.dk"}"
GIT_NAME="${GIT_NAME:-"Simon A. F. Lund"}"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git not found in PATH." >&2
  exit 1
fi

git config --global user.email "${GIT_EMAIL}"
git config --global user.name  "${GIT_NAME}"

echo "# git-config"
git config list
