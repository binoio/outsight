#!/bin/zsh
#
# test.sh: Run the Outsight test suites.
#
# Usage: Scripts/test.sh [--ui]
#   Runs the OutsightTests unit suite by default; --ui also runs OutsightUITests
#   (UI tests drive the real app and need a logged-in GUI session).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

ARGS=(-project Outsight.xcodeproj -scheme Outsight -derivedDataPath build/DerivedData -destination 'platform=macOS')
if [[ "${1:-}" == "--ui" ]]; then
    echo "==> Running unit and UI tests"
    xcodebuild test "${ARGS[@]}"
else
    echo "==> Running unit tests (OutsightTests)"
    xcodebuild test "${ARGS[@]}" -only-testing:OutsightTests
fi
