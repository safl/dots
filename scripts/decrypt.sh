#!/usr/bin/env bash
# Usage: decrypt.sh AGE_PATH BUNDLE_PATH REPO_PATH
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Error: Expected 3 arguments: AGE_PATH BUNDLE_PATH REPO_PATH" >&2
  exit 2
fi

AGE_PATH="$1"
BUNDLE_PATH="$2"
REPO_PATH="$3"

if [[ ! -e "${AGE_PATH}" ]]; then
  echo "Error: Encrypted bundle '${AGE_PATH}' does not exist. Nothing to decrypt."
  exit 1
fi

if [[ -e "${REPO_PATH}" ]]; then
  echo "Error: Repo '${REPO_PATH}' already exists. Remove it first."
  exit 1
fi

echo "Decrypting ${AGE_PATH} -> ${BUNDLE_PATH}..."
age -d -o "${BUNDLE_PATH}" "${AGE_PATH}"

echo "Cloning bundle into ${REPO_PATH}..."
git clone "${BUNDLE_PATH}" "${REPO_PATH}"

rm -f "${BUNDLE_PATH}"

cd "${REPO_PATH}"
git fsck --no-progress
