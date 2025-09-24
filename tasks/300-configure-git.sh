#!/usr/bin/env bash
# Configure git globally
# 
# Customize via env: GIT_NAME="Your Name" GIT_EMAIL="you@example.com" ./install-git.sh
set -euo pipefail

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git not found in PATH." >&2
  exit 1
fi

GIT_EMAIL="${GIT_EMAIL:-"os@safl.dk"}"
GIT_NAME="${GIT_NAME:-"Simon A. F. Lund"}"
git config --global user.email "${GIT_EMAIL}"
git config --global user.name  "${GIT_NAME}"
git config --global core.editor "hx"
git config --global diff.tool meld
git config --global difftool.prompt false
git config --global merge.tool meld
git config --global mergetool.prompt false

echo "# git-config"
git config list
