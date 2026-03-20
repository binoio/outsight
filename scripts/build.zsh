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

# Build
echo "${BLUE}Building Outsight app...${NC}"
xcodebuild -project Outsight.xcodeproj -scheme Outsight -configuration Debug build -sdk macosx

if [ $? -eq 0 ]; then
    echo "${GREEN}Build Succeeded!${NC}"
else
    echo "${RED}Build Failed!${NC}"
    exit 1
fi
