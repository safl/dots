#!/usr/bin/env bash
set -euo pipefail

taskdir="tasks"

echo "========================================"
echo "   🚀 Running setup tasks from $taskdir"
echo "========================================"
echo

i=1
for script in $(ls "$taskdir"/*.sh | sort); do
  name="$(basename "$script")"
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

