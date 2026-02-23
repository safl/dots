#!/usr/bin/env bash
# Install helix editor from source via cargo
set -euo pipefail

HELIX_VERSION="${HELIX_VERSION:-25.01.1}"
HELIX_DIR="${HOME}/src/helix"

if [[ -d "${HELIX_DIR}" ]]; then
  echo "Updating existing helix source in '${HELIX_DIR}'..."
  git -C "${HELIX_DIR}" fetch --tags
  git -C "${HELIX_DIR}" checkout "${HELIX_VERSION}"
else
  echo "Cloning helix source to '${HELIX_DIR}'..."
  mkdir -p "$(dirname "${HELIX_DIR}")"
  git clone --branch "${HELIX_VERSION}" https://github.com/helix-editor/helix.git "${HELIX_DIR}"
fi

echo "Building helix ${HELIX_VERSION}..."
cargo install --path "${HELIX_DIR}/helix-term" --locked

# Install runtime files
HELIX_RUNTIME="${HOME}/.config/helix/runtime"
mkdir -p "$(dirname "${HELIX_RUNTIME}")"
if [[ -L "${HELIX_RUNTIME}" ]]; then
  rm "${HELIX_RUNTIME}"
fi
ln -s "${HELIX_DIR}/runtime" "${HELIX_RUNTIME}"

echo "Helix ${HELIX_VERSION} installed successfully."
