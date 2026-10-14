#!/usr/bin/env bash
# Lints the mission's configs and SQF with HEMTT.
# HEMTT only understands addon projects, so this stages the mission as a throwaway
# addon (description.ext becomes addons/main/config.cpp) and runs `hemtt check` on it.
# Usage: tools/lint.sh   (needs `hemtt` on PATH: https://hemtt.dev)
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

addon="$stage/addons/main"
mkdir -p "$stage/.hemtt" "$addon"
cat > "$stage/.hemtt/project.toml" <<'TOML'
name = "Static Platoon Ops"
prefix = "spo"

[version]
major = 1
minor = 0
patch = 0
build = 0
git_hash = 0
TOML

# Copy every script and config, keeping the folder layout so #include paths resolve.
(cd "$root" && find . -path ./.git -prune -o -path ./tools -prune -o -path ./.github -prune -o \
    -type f \( -name '*.sqf' -o -name '*.hpp' \) -print) | while read -r file; do
    mkdir -p "$addon/$(dirname "$file")"
    cp "$root/$file" "$addon/$file"
done
cp "$root/description.ext" "$addon/config.cpp"
# Tell HEMTT which game version to check commands against (the mission needs 2.02+).
cat >> "$addon/config.cpp" <<'CPP'

class CfgPatches {
    class spo_main {
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.18;
        requiredAddons[] = {};
    };
};
CPP
printf 'z\\spo\\addons\\main' > "$addon/\$PBOPREFIX\$"

cd "$stage"
status=0
hemtt check "$@" || status=$?
# One line per finding (including warnings that don't fail the check), easier to scan than the report above.
if [ -f .hemttout/ci_annotations.txt ]; then
    echo "--- findings ---"
    cat .hemttout/ci_annotations.txt
fi
exit "$status"
