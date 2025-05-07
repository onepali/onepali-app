#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Cleaning the Flutter project...${NC}"
flutter clean

echo -e "${BLUE}📦 Running flutter pub get...${NC}"
flutter pub get

echo -e "${GREEN}✅ Build process completed successfully!${NC}"