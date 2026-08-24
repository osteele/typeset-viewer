#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
fixture_dir="$repo_root/fixtures/screenshots/adaptive-quadrature"
manifest="$repo_root/screenshots/manifest.json"

usage() {
    echo "usage: $0 launch APP_BUNDLE [document|reading-list|overleaf] | capture ASSET_ID" >&2
    exit 2
}

command=${1:-}
case "$command" in
    launch)
        app_bundle=${2:-}
        profile=${3:-document}
        [ -n "$app_bundle" ] || usage
        [ -d "$app_bundle" ] || { echo "App bundle not found: $app_bundle" >&2; exit 1; }
        capture_dir=$(mktemp -d "${TMPDIR:-/tmp}/typeset-viewer-site.XXXXXX")
        capture_home="$capture_dir/home"
        mkdir -p "$capture_home/Library/Application Support/Typeset Viewer"
        capture_app="$capture_dir/Typeset Viewer Site Capture.app"
        cp -R "$app_bundle" "$capture_app"
        capture_suffix=$(basename "$capture_dir" | tr -cd '[:alnum:]')
        /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.osteele.TypesetViewer.SiteCapture.$capture_suffix" "$capture_app/Contents/Info.plist"
        codesign --force --deep --sign - "$capture_app" >/dev/null
        common_args="-ReviewIntegrationEnabled NO -RestoreWindowsOnLaunch NO -DefaultSidebarMode outline -DefaultZoomMode fitPage"

        case "$profile" in
            document)
                cp -R "$fixture_dir/." "$capture_dir/document"
                CFFIXED_USER_HOME="$capture_home" swift "$repo_root/screenshots/launch-app.swift" "$capture_app" $common_args "$capture_dir/document/main.typ"
                capture_path="$capture_dir/document/main.typ"
                ;;
            reading-list)
                cp -R "$fixture_dir/." "$capture_dir/document"
                cp "$repo_root/fixtures/screenshots/reading-list/ReadingList.json" "$capture_home/Library/Application Support/Typeset Viewer/ReadingList.json"
                CFFIXED_USER_HOME="$capture_home" swift "$repo_root/screenshots/launch-app.swift" "$capture_app" $common_args "$capture_dir/document/main.typ"
                capture_path="$capture_dir/document/main.typ"
                ;;
            overleaf)
                fake_remote="https://git@git.overleaf.com/0123456789abcdef01234567"
                /usr/bin/git clone --quiet --depth 1 https://github.com/osteele/typeset-viewer.git "$capture_dir/project"
                /usr/bin/git -C "$capture_dir/project" remote set-url origin "$fake_remote"
                GIT_CONFIG_COUNT=1 \
                GIT_CONFIG_KEY_0=url.https://github.com/osteele/typeset-viewer.git.insteadOf \
                GIT_CONFIG_VALUE_0="$fake_remote" \
                CFFIXED_USER_HOME="$capture_home" \
                swift "$repo_root/screenshots/launch-app.swift" "$capture_app" $common_args "$capture_dir/project/fixtures/screenshots/overleaf/main.tex"
                capture_path="$capture_dir/project/fixtures/screenshots/overleaf/main.tex"
                ;;
            *)
                usage
                ;;
        esac

        echo "Opened the $profile capture profile from $capture_path"
        echo "Capture app: $capture_app"
        echo "Capture workspace: $capture_dir"
        ;;
    capture)
        asset_id=${2:-}
        [ -n "$asset_id" ] || usage
        output=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .output' "$manifest")
        raw=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .rawCapture' "$manifest")
        mkdir -p "$(dirname "$repo_root/$raw")"
        window_owner=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .windowOwner // "Typeset Viewer"' "$manifest")
        window_title=$(jq -er --arg id "$asset_id" '.assets[] | select(.id == $id) | .windowTitle // empty' "$manifest" || true)
        if [ -n "$window_title" ]; then
            window_id=$(swift "$repo_root/screenshots/window-id.swift" "$window_owner" "$window_title")
        else
            window_id=$(swift "$repo_root/screenshots/window-id.swift" "$window_owner")
        fi
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
