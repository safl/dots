#!/usr/bin/env bash
# Configure git globally
set -euo pipefail

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
