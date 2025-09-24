#!/bin/bash

# iOS Release Build Script for O Nepali App
# This script automates the iOS build process

set -e  # Exit on any error

echo "🚀 Starting iOS Release Build Process..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build iOS with config and release
echo "🔧 Configuring iOS project for release..."
flutter build ios --config-only --release

echo "📱 Building iOS release..."
flutter build ios --release

# Optional: Build for specific device architecture
# flutter build ios --release --target-platform ios-arm64

echo "✅ iOS Release Build Complete!"
echo "📍 Build location: build/ios/iphoneos/"
echo ""
echo "Next steps:"
echo "1. Open ios/Runner.xcworkspace in Xcode"
echo "2. Archive and upload to App Store Connect"
echo "3. Or use: flutter build ipa --release"