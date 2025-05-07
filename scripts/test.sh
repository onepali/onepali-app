#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Running Flutter tests...${NC}"

# Run flutter test
if flutter test; then
    echo -e "${GREEN}✅ All tests passed successfully!${NC}"
else
    echo -e "${RED}❌ Some tests failed!${NC}"
    exit 1
fi
