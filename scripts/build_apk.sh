#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🛠️ Building APK with --split-per-abi...${NC}"

# Run the build command
if flutter build apk --split-per-abi; then
    echo -e "${GREEN}✅ APK build completed successfully!${NC}"
else
    echo -e "${RED}❌ APK build failed!${NC}"
    exit 1
fi
