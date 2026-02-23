#!/usr/bin/env bash
set -euo pipefail

no_secrets=false
for arg in "$@"; do
  case "$arg" in
    --no-secrets) no_secrets=true ;;
  esac
done

taskdir="tasks"

echo "========================================"
echo "   🚀 Running setup tasks from $taskdir"
if $no_secrets; then
  echo "      (skipping secrets tasks)"
fi
echo "========================================"
echo

i=1
for script in $(ls "$taskdir"/*.sh | sort); do
  name="$(basename "$script")"

  if $no_secrets && [[ "$name" == *secrets* ]]; then
    echo "[$i] ⏭ $name (skipped)"
    echo
    ((i++))
    continue
  fi

  echo "[$i] ➜ $name"

  if [[ "$name" == *sudo* ]]; then
    echo "    (running with sudo)"
    sudo bash -l "$script"
  else
    bash -l "$script"
  fi

  echo "    ✅ Done: $name"
  echo
  ((i++))
done

echo "========================================"
echo "   🎉 All tasks completed successfully!"
echo "========================================"
