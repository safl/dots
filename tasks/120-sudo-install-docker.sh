#!/usr/bin/env bash
# Install Docker Engine from official repos and enable non-root usage.
set -euo pipefail

if [[ ! -r /etc/os-release ]]; then
  echo "Error: /etc/os-release not found or unreadable." >&2
  exit 1
fi

# shellcheck disable=SC1091
. /etc/os-release

install_docker_apt() {
  apt-get -y install ca-certificates curl gnupg

  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL "https://download.docker.com/linux/${ID}/gpg" \
    -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" \
    > /etc/apt/sources-list.d/docker.list

  apt-get -y update
  apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_docker_dnf() {
  dnf -y install dnf-plugins-core
  dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

case "${ID}" in
  debian|ubuntu)   install_docker_apt ;;
  fedora)          install_docker_dnf ;;
  *)
    echo "Error: unsupported distro '${ID}' for Docker installation." >&2
    exit 1
    ;;
esac

systemctl enable --now docker

# Allow the calling (non-root) user to use Docker without sudo
if [[ -n "${SUDO_USER:-}" ]]; then
  usermod -aG docker "${SUDO_USER}"
  echo "Added '${SUDO_USER}' to the docker group (re-login to take effect)."
fi

echo "Docker installed successfully."
