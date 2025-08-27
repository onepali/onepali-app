# Shorebird Integration Guide - O Nepali App

## Overview
Shorebird enables instant code updates to Flutter apps without Play Store review delays. This documentation covers complete setup, workflows, and best practices for the O Nepali development team.

## Table of Contents
1. [Quick Start](#quick-start)
2. [Setup for New Developers](#setup-for-new-developers)
3. [Daily Workflow](#daily-workflow)
4. [Commands Reference](#commands-reference)
5. [Best Practices](#best-practices)
6. [Troubleshooting](#troubleshooting)
7. [Team Guidelines](#team-guidelines)

## Quick Start

### App Configuration
- **App Name**: onepali
- **App ID**: `cd4b3c9e-f536-448c-b4ef-edce4680b11e`
- **Current Version**: 1.0.0+4
- **Platform**: Android (iOS can be added later)

### Key Files
- `shorebird.yaml` - Shorebird configuration
- `pubspec.yaml` - Contains shorebird.yaml as asset
- Generated AAB: `build/app/outputs/bundle/release/app-release.aab`

## Setup for New Developers

### 1. Install Shorebird CLI
```bash
# Install Shorebird CLI
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash

# Add to PATH (add this to your ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.shorebird/bin:$PATH"

# Verify installation
shorebird --version
```

### 2. Login to Shorebird
```bash
# Login (will open browser for authentication)
shorebird login

# Verify login
shorebird account
```

### 3. Project Setup (Already Done)
The project is already initialized with Shorebird. You should see:
- `shorebird.yaml` file in root directory
- `shorebird.yaml` listed in `pubspec.yaml` assets

## Daily Workflow

### Scenario 1: Bug Fix or Feature Update (Most Common)
```bash
# 1. Make your code changes in lib/ folder
# 2. Test locally
flutter run

# 3. Create and push patch (instant update)
export PATH="$HOME/.shorebird/bin:$PATH"
shorebird patch android

# That's it! Users get the update automatically
```

### Scenario 2: Major Version Release (Less Common)
```bash
# 1. Update version in pubspec.yaml
version: 1.0.1+5  # Increment version

# 2. Make your changes (can include native code, assets, dependencies)
# 3. Test locally
flutter run

# 4. Create new release
export PATH="$HOME/.shorebird/bin:$PATH"
shorebird release android

# 5. Upload generated AAB to Play Store
# File: build/app/outputs/bundle/release/app-release.aab
```

## Commands Reference

### Essential Commands
```bash
# Set PATH (run this in each terminal session)
export PATH="$HOME/.shorebird/bin:$PATH"

# Create patch for existing version (most used)
shorebird patch android

# Create patch for specific version
shorebird patch android --release-version=1.0.0+4

# Create new release (for Play Store)
shorebird release android

# Preview patch before releasing
shorebird preview android
```

### Monitoring Commands
```bash
# List all apps
shorebird apps list

# List all releases
shorebird releases list

# List all patches
shorebird patches list

# Get detailed patch info
shorebird patches list --release-version=1.0.0+4
```

### Account Management
```bash
# Check current account
shorebird account

# Logout
shorebird logout

# Login
shorebird login
```

## Understanding Shorebird Updates

### How Automatic Updates Work
1. **App Start**: Your app checks Shorebird servers for updates
2. **Background Download**: If updates exist, they download silently  
3. **Next Restart**: Updates are applied when user restarts the app
4. **Seamless Experience**: Users get updates without manual intervention

### Two Types of Updates

#### 1. Patches (Instant Updates) - 99% of cases
```bash
shorebird patch android
```
- ✅ **For**: Bug fixes, UI changes, Dart code updates
- ✅ **Updates**: Existing app version (e.g., 1.0.0+4)
- ✅ **Speed**: Instant delivery to users
- ✅ **Play Store**: No upload needed
- ✅ **Review**: No Google review required

#### 2. Releases (New Versions) - 1% of cases  
```bash
shorebird release android
```
- ❗ **For**: Native code, new dependencies, assets, permissions
- ❗ **Creates**: New app version (e.g., 1.0.0+5)
- ❗ **Speed**: 3-4 days Google review
- ❗ **Play Store**: New AAB upload required
- ❗ **Review**: Full Google review process

### What Can Be Patched vs Released

#### ✅ Can be PATCHED (Instant Updates):
- Changes in `lib/` folder (all Dart code)
- UI updates and styling
- Business logic changes
- Bug fixes
- Text content updates
- API endpoint changes
- State management updates
- Navigation changes

#### ❌ Must be RELEASED (Play Store Update):
- Changes in `android/` or `ios/` folders
- New dependencies in `pubspec.yaml`
- New assets (images, fonts, etc.)
- Permission changes in `AndroidManifest.xml`
- Native plugin updates
- Flutter SDK version changes

## Best Practices

### Development Workflow
1. **Always test locally first**: `flutter run`
2. **Use patches for quick fixes**: Most updates should be patches
3. **Preview before releasing**: `shorebird preview android`
4. **Monitor patch success**: Check logs and user feedback
5. **Keep releases minimal**: Only when absolutely necessary

### Code Organization
```dart
// Good: This can be patched instantly
class UserService {
  static const String apiUrl = 'https://api.onepali.com'; // ✅ Patchable
  
  Future<User> getUser() async {
    // Business logic changes - ✅ Patchable
    return await http.get(apiUrl);
  }
}

// Bad: This requires a new release
// Adding new dependency in pubspec.yaml - ❌ Needs release
```

### Version Management
```yaml
# pubspec.yaml
version: 1.0.0+4  # Keep this same for patches

# Only increment for major changes that need Play Store release:
version: 1.0.1+5  # New release needed
```

### Team Coordination
- **Who can patch**: Anyone with Shorebird access
- **Who can release**: Lead developers only
- **Communication**: Notify team before releasing patches
- **Testing**: Always test patches in staging first

## Step-by-Step Implementation Guide

### For New Team Members

#### Step 1: Environment Setup
```bash
# 1. Install Shorebird CLI
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash

# 2. Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
echo 'export PATH="$HOME/.shorebird/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 3. Verify installation
shorebird --version
```

#### Step 2: Authentication
```bash
# Login to Shorebird (opens browser)
shorebird login

# Verify you're logged in
shorebird account
```

#### Step 3: Verify Project Access
```bash
# Navigate to project directory
cd /path/to/onepali

# Check if you can see the app
shorebird apps list

# Should show: onepali (cd4b3c9e-f536-448c-b4ef-edce4680b11e)
```

### Daily Development Workflow

#### Scenario A: Quick Bug Fix
```bash
# 1. Pull latest code
git pull origin main

# 2. Create feature branch
git checkout -b fix/button-alignment

# 3. Make your changes in lib/ folder
# Example: Fix button alignment in lib/screens/home_screen.dart

# 4. Test locally
flutter run

# 5. Commit changes
git add .
git commit -m "Fix: Adjust button alignment on home screen"
git push origin fix/button-alignment

# 6. After code review and merge to main:
git checkout main
git pull origin main

# 7. Deploy patch instantly
export PATH="$HOME/.shorebird/bin:$PATH"
shorebird patch android

# 8. Verify patch was created
shorebird patches list
```

#### Scenario B: New Feature Development
```bash
# 1. Development process (same as above)
# 2. Make changes in lib/ folder only
# 3. Test thoroughly
# 4. Deploy as patch (same as bug fix)

# Example changes that can be patched:
# - New screen in lib/screens/
# - New widget in lib/widgets/
# - API integration in lib/services/
# - State management updates
```

#### Scenario C: Major Update (Rare)
```bash
# Only when you need to:
# - Add new dependency
# - Change native code
# - Add new assets

# 1. Update version in pubspec.yaml
version: 1.0.1+5  # Increment

# 2. Make your changes
# 3. Create new release
shorebird release android

# 4. Upload new AAB to Play Store
# File: build/app/outputs/bundle/release/app-release.aab

# 5. Wait for Google approval (3-4 days)
```

## Troubleshooting

### Common Issues

#### 1. "shorebird: command not found"
```bash
# Solution: Add to PATH
export PATH="$HOME/.shorebird/bin:$PATH"

# Permanent fix: Add to shell profile
echo 'export PATH="$HOME/.shorebird/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### 2. "No releases found"
```bash
# Check if you have any releases
shorebird releases list

# If empty, create first release
shorebird release android
```

#### 3. "Authentication failed"
```bash
# Re-login to Shorebird
shorebird logout
shorebird login
```

#### 4. "Patch failed to apply"
```bash
# Check what went wrong
shorebird patches list --release-version=1.0.0+4

# Try creating patch for specific release
shorebird patch android --release-version=1.0.0+4
```

#### 5. "Build failed"
```bash
# Clean and rebuild
flutter clean
flutter pub get

# Try building locally first
flutter build appbundle --release

# Then try patch again
shorebird patch android
```

### Debug Commands
```bash
# Check current status
shorebird doctor

# Verbose logging
shorebird patch android --verbose

# Check app configuration
shorebird apps list

# Check release history
shorebird releases list

# Check patch history
shorebird patches list
```
## Security Considerations

### Access Control
- Only authorized developers have Shorebird access
- Use company email for Shorebird accounts
- Regularly review team access
- Implement code review for all patches

### Code Signing
- Patches are automatically signed by Shorebird
- Uses same signature as original app
- No additional signing needed

### Data Protection
- Shorebird only accesses Dart code
- No user data is transmitted
- Updates are encrypted in transit

## FAQs

### Q: Can I patch native Android code?
**A:** No, only Dart code in the `lib/` folder can be patched. Native code changes require a new release.

### Q: How long do patches take to reach users?
**A:** Usually within minutes. Users get updates when they restart the app.

### Q: Can I rollback a patch?
**A:** Not directly, but you can create a new patch that reverts the changes.

### Q: Do patches work offline?
**A:** Patches are downloaded when the app has internet. Once downloaded, they work offline.

### Q: Is there a size limit for patches?
**A:** Patches are usually small (few KB to few MB) since they only contain code differences.

### Q: Can I schedule patches?
**A:** No, patches are deployed immediately. Users get them on next app restart.

### Q: What happens if a patch fails?
**A:** The app continues with the previous version. Shorebird handles failures gracefully.

### External Support
- **Shorebird Docs**: https://docs.shorebird.dev
- **Shorebird Support**: https://discord.gg/shorebird
- **GitHub Issues**: https://github.com/shorebirdtech/shorebird
