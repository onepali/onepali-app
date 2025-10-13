#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🛠️ Building APK with --split-per-abi and release obfuscation...${NC}"

# Run the build command with obfuscation
if flutter build apk --split-per-abi --obfuscate --split-debug-info=build/app/outputs/symbols; then
    echo -e "${GREEN}✅ APK build completed successfully!${NC}"
    echo -e "${GREEN}📁 Debug symbols saved to: build/app/outputs/symbols${NC}"
else
    echo -e "${RED}❌ APK build failed!${NC}"
    exit 1
fi
