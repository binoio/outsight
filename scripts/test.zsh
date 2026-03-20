#!/bin/zsh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "${BLUE}Running Outsight Tests...${NC}"

# Test
echo "${BLUE}Executing Unit and UI tests...${NC}"
xcodebuild -project Outsight.xcodeproj -scheme Outsight -configuration Debug test -sdk macosx

if [ $? -eq 0 ]; then
    echo "${GREEN}Tests Passed!${NC}"
else
    echo "${RED}Tests Failed!${NC}"
    exit 1
fi
