#!/usr/bin/env bash
set -euo pipefail

# Usage: encrypt.sh AGE_PATH BUNDLE_PATH REPO_PATH

if [[ $# -ne 3 ]]; then
  echo "Error: Expected 3 arguments: AGE_PATH BUNDLE_PATH REPO_PATH" >&2
  exit 2
fi

AGE_PATH="$1"
BUNDLE_PATH="$2"
REPO_PATH="$3"

if [[ ! -d "${REPO_PATH}" ]]; then
  echo "Error: Repo '${REPO_PATH}' does not exist; nothing to encrypt."
  exit 1
fi

if [[ -e "${AGE_PATH}" ]]; then
  echo "Error: Encrypted bundle '${AGE_PATH}' already exists. Remove it first."
  exit 1
fi

( cd "${REPO_PATH}" && git bundle create "${BUNDLE_PATH}" --all )

( cd "${HOME}" && age -e -p -o "${AGE_PATH}" "${BUNDLE_PATH}" )

rm -f "${BUNDLE_PATH}"
