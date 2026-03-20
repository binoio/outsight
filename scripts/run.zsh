#!/bin/zsh

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "${BLUE}Running Outsight...${NC}"

# Get the path to the app
APP_PATH=$(xcodebuild -project Outsight.xcodeproj -scheme Outsight -configuration Debug -showBuildSettings | grep -w TARGET_BUILD_DIR | awk '{print $3}')/Outsight.app

if [ -d "$APP_PATH" ]; then
    echo "${GREEN}Launching app at $APP_PATH...${NC}"
    open "$APP_PATH"
else
    echo "App not found. Please build first using scripts/build.zsh"
    exit 1
fi
