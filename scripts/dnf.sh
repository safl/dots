#!/usr/bin/env bash
set -euo pipefail

dnf -y upgrade --refresh
dnf -y install \
  age \
  btop \
  gcc \
  git \
  htop \
  make \
  meld \
  meson \
  pipx \
  pkgconf-pkg-config \
  screen

# openssl-devel is needed to build zellij from source
dnf -y install openssl-devel
