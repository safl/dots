#!/usr/bin/env bash
set -euo pipefail

# Runs the OS-specific script in ./scripts/${ID}.sh using /etc/os-release
# Usage: ./install-packages.sh
# Expects: ./scripts/<ID>.sh to exist (e.g., debian.sh, fedora.sh, arch.sh)

if [[ ! -r /etc/os-release ]]; then
  echo "Error: /etc/os-release not found or unreadable." >&2
  exit 1
fi

# shellcheck disable=SC1091
. /etc/os-release

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}" && pwd)"
target="${repo_root}/scripts/${ID}.sh"

if [[ ! -x "${target}" ]]; then
  if [[ -f "${target}" ]]; then
    echo "Making ${target} executable..."
    chmod +x "${target}"
  else
    echo "Error: '${target}' not found." >&2
    exit 1
  fi
fi

echo "Running ${target} with sudo..."
exec sudo "${target}"
