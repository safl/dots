#!/usr/bin/env bash
# Runs the package-manager script matching the current distro.
# Maps distro IDs from /etc/os-release to scripts (e.g., apt.sh, dnf.sh).
set -euo pipefail

if [[ ! -r /etc/os-release ]]; then
  echo "Error: /etc/os-release not found or unreadable." >&2
  exit 1
fi

# shellcheck disable=SC1091
. /etc/os-release

# Map distro ID to package-manager script name
case "${ID}" in
  debian|ubuntu|linuxmint|pop) pkgmgr="apt" ;;
  fedora|rhel|centos|rocky|alma) pkgmgr="dnf" ;;
  *) pkgmgr="${ID}" ;;
esac

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
target="${repo_root}/scripts/${pkgmgr}.sh"

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
exec "${target}"
