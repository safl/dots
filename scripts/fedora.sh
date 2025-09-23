#!/usr/bin/env bash
set -euo pipefail

sudo dnf -y upgrade --refresh
sudo dnf -y install \
  age \
  btop \
  gcc \
  git \
  htop \
  make \
  meld \
  meson \
  openssl-devel \
  pipx \
  pkgconf-pkg-config

# openssl-devel is needed to build zellij from source
