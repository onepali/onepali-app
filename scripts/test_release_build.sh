#!/bin/bash

# Build script for testing release APK with secure downloads

echo "🧹 Cleaning previous builds..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Building release APK..."
flutter build apk --release --verbose

echo "✅ Build completed!"
echo "📱 Install the APK from: build/app/outputs/flutter-apk/app-release.apk"
echo "🐛 Check logs with: adb logcat | grep -E '(FileDownloadUtility|PrintablesProvider|onepali)'"