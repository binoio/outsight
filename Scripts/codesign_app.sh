#!/bin/zsh
#
# codesign_app.sh: Sign Outsight.app inside-out (never --deep) with hardened
# runtime. Sparkle's helpers are signed individually; its XPC services keep
# their shipped entitlements.
#
# Usage: Scripts/codesign_app.sh <path/to/Outsight.app> <signing-identity>

set -euo pipefail

APP_BUNDLE="${1:?usage: codesign_app.sh <app> <identity>}"
IDENTITY="${2:?usage: codesign_app.sh <app> <identity>}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENTITLEMENTS="$REPO_ROOT/Outsight/Outsight.entitlements"

CODESIGN_FLAGS=(--force --options runtime --timestamp -s "$IDENTITY")

SPARKLE_FRAMEWORK="$APP_BUNDLE/Contents/Frameworks/Sparkle.framework"
if [[ -d "$SPARKLE_FRAMEWORK" ]]; then
    echo "Step 1/2: Signing Sparkle.framework..."
    codesign "${CODESIGN_FLAGS[@]}" "$SPARKLE_FRAMEWORK/Versions/B/Autoupdate"
    codesign "${CODESIGN_FLAGS[@]}" "$SPARKLE_FRAMEWORK/Versions/B/Updater.app"
    codesign "${CODESIGN_FLAGS[@]}" --preserve-metadata=entitlements "$SPARKLE_FRAMEWORK/Versions/B/XPCServices/Installer.xpc"
    codesign "${CODESIGN_FLAGS[@]}" --preserve-metadata=entitlements "$SPARKLE_FRAMEWORK/Versions/B/XPCServices/Downloader.xpc"
    codesign "${CODESIGN_FLAGS[@]}" "$SPARKLE_FRAMEWORK"
else
    echo "Step 1/2: No Sparkle.framework embedded; skipping."
fi

echo "Step 2/2: Signing app bundle..."
if [[ -f "$ENTITLEMENTS" ]]; then
    codesign "${CODESIGN_FLAGS[@]}" --entitlements "$ENTITLEMENTS" "$APP_BUNDLE"
else
    codesign "${CODESIGN_FLAGS[@]}" "$APP_BUNDLE"
fi

echo "Code signing complete (inner-to-outer)."
