#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Running Flutter analyze...${NC}"

# Run flutter analyze
if flutter analyze; then
    echo -e "${GREEN}✅ Analysis completed successfully!${NC}"
else
    echo -e "${RED}❌ Analysis found issues!${NC}"
    exit 1
fi
