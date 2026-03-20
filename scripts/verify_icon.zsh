#!/bin/zsh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "${BLUE}Verifying App Icon...${NC}"

# Check current directory first
if [ -d "Outsight.app" ]; then
    APP_PATH="./Outsight.app"
else
    # Get the path to the app from build settings
    APP_PATH=$(xcodebuild -project Outsight.xcodeproj -scheme Outsight -configuration Debug -showBuildSettings | grep -w TARGET_BUILD_DIR | awk '{print $3}')/Outsight.app
fi

if [ ! -d "$APP_PATH" ]; then
    echo "${RED}Error: App not found at $APP_PATH. Please build first.${NC}"
    exit 1
fi

ICON_FILE="$APP_PATH/Contents/Resources/AppIcon.icns"

if [ -f "$ICON_FILE" ]; then
    echo "${GREEN}Success: AppIcon.icns found at $ICON_FILE${NC}"
    # Check size of the icns file - placeholder icons are usually very small or have specific signatures
    SIZE=$(stat -f%z "$ICON_FILE")
    echo "Icon file size: $SIZE bytes"
    if [ "$SIZE" -lt 1000 ]; then
        echo "${RED}Warning: AppIcon.icns is suspiciously small ($SIZE bytes). It might be a placeholder.${NC}"
        exit 1
    else
        echo "${GREEN}AppIcon.icns size looks healthy.${NC}"
    fi
else
    echo "${RED}Error: AppIcon.icns NOT found in the app bundle!${NC}"
    exit 1
fi
