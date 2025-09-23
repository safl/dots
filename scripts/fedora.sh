#!/usr/bin/env bash
set -euo pipefail

sudo dnf -y upgrade --refresh
sudo dnf -y install \
  git \
  htop \
  btop \
  meson \
  openssl-devel \
  pkgconf-pkg-config \
  gcc \
  make

# openssl-devel is needed to build zellij from source
