#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
fixture_dir="$repo_root/fixtures/screenshots/adaptive-quadrature"
manifest="$repo_root/screenshots/manifest.json"

usage() {
    echo "usage: $0 launch APP_BUNDLE | capture ASSET_ID" >&2
    exit 2
}

command=${1:-}
case "$command" in
    launch)
        app_bundle=${2:-}
        [ -n "$app_bundle" ] || usage
        [ -d "$app_bundle" ] || { echo "App bundle not found: $app_bundle" >&2; exit 1; }
        capture_dir=$(mktemp -d "${TMPDIR:-/tmp}/typeset-viewer-site.XXXXXX")
        cp -R "$fixture_dir/." "$capture_dir/"
        open -n "$app_bundle" --args \
            -ReviewIntegrationEnabled NO \
            -RestoreWindowsOnLaunch NO \
            -DefaultSidebarMode outline \
            -DefaultZoomMode fitPage \
            "$capture_dir/main.typ"
        echo "Opened the standalone capture profile from $capture_dir/main.typ"
        ;;
    capture)
        asset_id=${2:-}
        [ -n "$asset_id" ] || usage
        output=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .output' "$manifest")
        raw=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .rawCapture' "$manifest")
        mkdir -p "$(dirname "$repo_root/$raw")"
        window_id=$(swift "$repo_root/screenshots/window-id.swift")
        screencapture -l "$window_id" -o "$repo_root/$raw"
        crop_width=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .crop.width // empty' "$manifest" || true)
        if [ -n "$crop_width" ]; then
            crop_height=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .crop.height' "$manifest")
            crop_x=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .crop.x' "$manifest")
            crop_y=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .crop.y' "$manifest")
            magick "$repo_root/$raw" -crop "${crop_width}x${crop_height}+${crop_x}+${crop_y}" +repage "$repo_root/$output"
        else
            cp "$repo_root/$raw" "$repo_root/$output"
        fi
        echo "Captured $output"
        ;;
    *)
        usage
        ;;
esac
