#!/usr/bin/env bash
set -euo pipefail

src_dir="../../secrets/etc"
dst_dir="/etc"

begin="# BEGIN: Customization"
end="# END: Customization"

find "$src_dir" -type f -print0 | while IFS= read -r -d '' src_file; do
    rel="${src_file#$src_dir/}"
    dst="$dst_dir/$rel"

    if [[ -f "$dst" ]]; then
        if ! grep -Fq "$begin" "$dst"; then
            echo "Appending $src_file → $dst"
            {
                echo
                echo "$begin"
                cat "$src_file"
                echo "$end"
            } | sudo tee -a "$dst" >/dev/null
        else
            echo "Skipping $dst (already customized)"
        fi
    fi
done
