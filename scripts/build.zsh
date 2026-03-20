#!/bin/zsh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "${BLUE}Starting Outsight Build...${NC}"

# Generate project
echo "${BLUE}Generating Xcode project...${NC}"
xcodegen generate

# Generate icons
echo "${BLUE}Generating App Icons...${NC}"
swift scripts/generate_icons.swift

# Build
echo "${BLUE}Building Outsight app...${NC}"
xcodebuild -project Outsight.xcodeproj -scheme Outsight -configuration Debug build -sdk macosx

if [ $? -eq 0 ]; then
    echo "${GREEN}Build Succeeded!${NC}"
    
    # Get the path to the app
    APP_PATH=$(xcodebuild -project Outsight.xcodeproj -scheme Outsight -configuration Debug -showBuildSettings | grep -w TARGET_BUILD_DIR | awk '{print $3}')/Outsight.app
    
    # Copy to project root for visibility
    echo "${BLUE}Copying Outsight.app to project root...${NC}"
    cp -R "$APP_PATH" .
    
    # Touch the app to force Finder to update icon
    touch Outsight.app
    
    # Verify icon
    ./scripts/verify_icon.zsh
else
    echo "${RED}Build Failed!${NC}"
    exit 1
fi
