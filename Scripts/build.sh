#!/bin/zsh
#
# build.sh: Build Outsight.app.
#
# Usage: Scripts/build.sh [--release]
#   Debug build by default. --release builds the Release configuration
#   (unsigned; Scripts/release.sh handles signing and notarization).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

CONFIGURATION="Debug"
if [[ "${1:-}" == "--release" ]]; then
    CONFIGURATION="Release"
fi

DERIVED_DATA="build/DerivedData"

echo "==> Building Outsight ($CONFIGURATION)"
xcodebuild \
    -project Outsight.xcodeproj \
    -scheme Outsight \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$DERIVED_DATA" \
    -destination 'generic/platform=macOS' \
    build

APP="$DERIVED_DATA/Build/Products/$CONFIGURATION/Outsight.app"
echo "==> Built $APP"
