#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_scad="$repo_dir/cad/core-assembly-v0.1.scad"
output_dir="$repo_dir/visualization/assets"

if ! command -v openscad >/dev/null 2>&1; then
  echo "OpenSCAD CLI is required." >&2
  exit 1
fi

mkdir -p "$output_dir"

parts=(
  front-core
  rear-core
  board-spine-front
  board-spine-rear
  front-panel
  front-button-mount
  front-usb-cassette
  ssd-cassette
  esp32-cassette
  rear-blank-board
  rear-blank-psu
  rear-cover-horizontal
  rear-cover-vertical
)

for part in "${parts[@]}"; do
  echo "Exporting $part"
  openscad \
    -o "$output_dir/$part.stl" \
    -D "part=\"$part\"" \
    "$source_scad"
done

intake_source="$repo_dir/cad/intake-panel-snap-v0.1.scad"
for part in left right; do
  echo "Exporting intake-cover-$part"
  openscad \
    -o "$output_dir/intake-cover-$part.stl" \
    -D "part=\"$part\"" \
    "$intake_source"
done

reference_source="$repo_dir/cad/visualization-reference-parts.scad"
reference_parts=(button-plate button-light-pipe usb-cover)

for part in "${reference_parts[@]}"; do
  echo "Exporting supplied reference $part"
  openscad \
    -o "$output_dir/$part.stl" \
    -D "part=\"$part\"" \
    "$reference_source"
done

python3 "$repo_dir/tools/extract_nexgen_button_materials.py" \
  "$repo_dir/references/printables-1793043-nexgen-pro-v2/Power Button/pro-v2-steam-logo.3mf" \
  "$repo_dir/cad/vendor/nexgen"

for entry in "button-cap-black:black" "button-logo-white:white"; do
  asset="${entry%%:*}"
  material_part="${entry##*:}"
  echo "Exporting $asset"
  openscad \
    -o "$output_dir/$asset.stl" \
    -D "part=\"$material_part\"" \
    "$repo_dir/cad/visualization-nexgen-button-material.scad"
done

echo "Exporting button-decorative-bezel"
openscad \
  -o "$output_dir/button-decorative-bezel.stl" \
  "$repo_dir/cad/visualization-decorative-button.scad"

echo "Exported $((${#parts[@]} + ${#reference_parts[@]} + 5)) visualization assets to $output_dir"
