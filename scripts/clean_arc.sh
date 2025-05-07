#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📦 Creating clean architecture folder structure...${NC}"

# Create main app folders
mkdir -p lib/src/{config,core/{constants,errors,utils,services},data/{models,datasources,repositories},domain/{entities,usecases,repositories},presentation/{screens,widgets,viewmodels}}

# Create injector and main files
touch lib/src/injector.dart
touch lib/main.dart

echo -e "${GREEN}✅ Structure generated successfully!${NC}"