#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🖊️ Formatting Flutter code...${NC}"

# Run flutter format
if flutter format .; then
    echo -e "${GREEN}✅ Code formatted successfully!${NC}"
else
    echo -e "${RED}❌ Code formatting failed!${NC}"
    exit 1
fi
