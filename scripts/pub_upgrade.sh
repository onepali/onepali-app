#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}⬆️ Upgrading Flutter dependencies...${NC}"

# Run flutter pub upgrade
if flutter pub upgrade; then
    echo -e "${GREEN}✅ Dependencies upgraded successfully!${NC}"
else
    echo -e "${RED}❌ Dependency upgrade failed!${NC}"
    exit 1
fi
