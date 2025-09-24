#!/usr/bin/env bash
# Install zellij via cargo
set -euo pipefail

# Avoid vendored OpenSSL to use system OpenSSL
OPENSSL_NO_VENDOR=1 cargo install zellij
