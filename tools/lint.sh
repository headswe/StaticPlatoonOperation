#!/usr/bin/env bash
# Lints the mission's configs and SQF with HEMTT.
# HEMTT only understands addon projects, so this stages the mission as a throwaway
# addon (description.ext becomes config.cpp) and runs `hemtt check` on it.
# Usage: tools/lint.sh   (needs `hemtt` on PATH: https://hemtt.dev)
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

addon="$stage/addons/spo"
mkdir -p "$stage/.hemtt" "$addon"
cat > "$stage/.hemtt/project.toml" <<'TOML'
name = "Static Platoon Ops"
prefix = "spo"
TOML

# Copy every script and config, keeping the folder layout so #include paths resolve.
(cd "$root" && find . -path ./.git -prune -o -path ./tools -prune -o -path ./.github -prune -o \
    -type f \( -name '*.sqf' -o -name '*.hpp' \) -print) | while read -r file; do
    mkdir -p "$addon/$(dirname "$file")"
    cp "$root/$file" "$addon/$file"
done
cp "$root/description.ext" "$addon/config.cpp"

# HEMTT derives the version from git.
git -C "$stage" init -q
git -C "$stage" -c user.name=lint -c user.email=lint@localhost add -A
git -C "$stage" -c user.name=lint -c user.email=lint@localhost commit -qm lint

cd "$stage"
hemtt check "$@"
