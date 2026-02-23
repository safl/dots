#!/usr/bin/env bash
set -euo pipefail

apt-get -y update
apt-get -y upgrade
apt-get -y install \
  age \
  btop \
  gcc \
  git \
  helix \
  htop \
  make \
  meld \
  meson \
  pipx \
  pkg-config \
  screen

# libssl-dev is needed to build zellij from source
apt-get -y install libssl-dev
