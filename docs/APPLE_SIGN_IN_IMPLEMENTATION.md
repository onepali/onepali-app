# Apple Sign In Implementation Guide

This document outlines the steps to replace Facebook login with Apple Sign In in the O Nepali app.

## Overview

The current authentication system uses:
- **Facebook Login**: `flutter_facebook_auth` package
- **Google Login**: `google_sign_in` package  
- **Email/Password**: Custom Firebase Auth

We need to replace Facebook login with Apple Sign In while maintaining the same authentication flow and user data structure.

## Prerequisites

1. Apple Developer Account (required for Sign in with Apple)
2. Firebase project configured with Apple Sign In
3. iOS app configured in Apple Developer Portal

---

## Step 1: Add Apple Sign In Package

### 1.1 Update `pubspec.yaml`

Add the `sign_in_with_apple` package:

```yaml
dependencies:
  # ... existing dependencies
  sign_in_with_apple: ^6.1.3  # Add this line
```

Run:
```bash
flutter pub get
```

---

## Step 2: Configure Apple Developer Portal

### 2.1 Enable Sign in with Apple Capability

1. Log in to [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Select **Identifiers** → Your App ID
4. Enable **Sign in with Apple** capability
5. Save changes

### 2.2 Configure Service ID (if needed for web)

If you plan to support web authentication later:
1. Create a **Service ID** in Apple Developer Portal
2. Configure domains and redirect URLs
3. Enable Sign in with Apple

---

## Step 3: Configure iOS Project

### 3.1 Update Xcode Project

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** target
3. Go to **Signing & Capabilities** tab
4. Click **+ Capability**
5. Add **Sign in with Apple**
6. Ensure your provisioning profile includes this capability

### 3.2 Update Info.plist (if needed)

The `sign_in_with_apple` package should handle this automatically, but verify:
- Bundle identifier matches your Apple Developer App ID
- Team ID is correctly set in Xcode

---

## Step 4: Configure Firebase

### 4.1 Enable Apple Sign In in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Authentication** → **Sign-in method**
4. Enable **Apple** as a sign-in provider
5. Configure OAuth redirect URLs if needed

### 4.2 Update Firebase iOS Configuration

Ensure `GoogleService-Info.plist` is up to date in `ios/Runner/`

---

## Step 5: Create Apple Auth Provider

### 5.1 Create New Provider File

Create `lib/src/provider/auth/aauth_provider.dart` (Apple Auth Provider):

```dart
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../src.dart';

class AAuthProvider with ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final SharedPreferencesService _sharedPrefs = SharedPreferencesService();
  final AuthState authState;

  AAuthProvider({required this.authState});

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  Future<void> signInWithApple(BuildContext context) async {
    setStatus(DataFetchStatus.loading);

    try {
      // Request Apple Sign In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth credential from Apple ID token
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with Apple credential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );

      final firebaseUser = userCredential.user;

      // Prepare user info map
      final String fullName = appleCredential.givenName != null && 
                             appleCredential.familyName != null
          ? '${appleCredential.givenName} ${appleCredential.familyName}'
          : appleCredential.givenName ?? 
            appleCredential.familyName ?? 
            firebaseUser?.displayName ?? 
            '';

      final Map<String, dynamic> userInfo = {
        'full_name': fullName,
        'email': appleCredential.email ?? firebaseUser?.email ?? '',
        'user_dp': firebaseUser?.photoURL ?? '',
        'login_type': AppConstants.apple,
        'access_token': appleCredential.identityToken ?? '',
      };

      await _sharedPrefs.setStringPref(
        AppConstants.accessToken,
        appleCredential.identityToken ?? '',
      );
      await _sharedPrefs.setStringPref(
        AppConstants.userInfo,
        json.encode(userInfo),
      );
      await _sharedPrefs.setBoolPref(AppConstants.logged, true);

      // Save UserModel to Firestore
      final user = firebaseUser;
      if (user != null) {
        final userDocRef = FirebaseFirestore.instance
            .collection(AppConstants.usersCollection)
            .doc(user.uid);

        final userModel = UserModel(
          uid: user.uid,
          fullName: authState.fullName ?? fullName,
          email: appleCredential.email ?? user.email ?? "",
          yearOfBirth: authState.yearOfBirth ?? 0,
          heardAbout: authState.heardAbout ?? "",
          learningReason: authState.learningReason ?? "",
          authProvider: AuthProviderType.apple.name,
          createdAt: DateTime.now().toIso8601String(),
        );
        logger.d('userModel---> ${userModel.toJson()}');

        final docSnapshot = await userDocRef.get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          final Map<String, dynamic> updateData = {};

          if ((data['full_name'] == null ||
                  (data['full_name'] as String).isEmpty) &&
              userModel.fullName.isNotEmpty) {
            updateData['full_name'] = userModel.fullName;
          }
          if ((data['year_of_birth'] == null || data['year_of_birth'] == 0) &&
              userModel.yearOfBirth != 0) {
            updateData['year_of_birth'] = userModel.yearOfBirth;
          }
          if ((data['heard_about'] == null ||
                  (data['heard_about'] as String).isEmpty) &&
              userModel.heardAbout.isNotEmpty) {
            updateData['heard_about'] = userModel.heardAbout;
          }
          if ((data['learning_reason'] == null ||
                  (data['learning_reason'] as String).isEmpty) &&
              userModel.learningReason.isNotEmpty) {
            updateData['learning_reason'] = userModel.learningReason;
          }
          if ((data['auth_provider'] == null ||
              (data['auth_provider'] as String).isEmpty)) {
            updateData['auth_provider'] = userModel.authProvider;
          }
          if (data['created_at'] == null) {
            updateData['created_at'] = userModel.createdAt;
          }

          if (updateData.isNotEmpty) {
            logger.d('Firestore updateData ---> ${json.encode(updateData)}');
            await userDocRef.update(updateData);
          }
        } else {
          logger.d(
            'Firestore set userModel ---> ${json.encode(userModel.toJson())}',
          );
          await userDocRef.set(userModel.toJson());
        }
        // Save FCM token after Apple login/registration
        await Utility.saveFcmTokenToFirestore(user.uid);
      }

      logger.d('Apple identityToken---> ${appleCredential.identityToken}');
      logger.d(
        'logged---> ${await _sharedPrefs.getBoolPref(AppConstants.logged)}',
      );

      if (!context.mounted) return;
      _status = DataFetchStatus.success;
      notifyListeners();

      if (!context.mounted) return;
      onNavigate(context);
      showCustomToaster('Login Successful');
      return;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (!context.mounted) return;
      logger.e('Apple Sign In AuthorizationException: code=${e.code}, message=${e.message}');
      
      if (e.code == AuthorizationErrorCode.canceled) {
        handleError("Apple Sign In cancelled.", context);
      } else if (e.code == AuthorizationErrorCode.unknown) {
        // Error 1000 - Unknown error
        logger.e('Apple Sign In Error 1000 (Unknown). Common causes: missing capability, provisioning profile, or 2FA not enabled.');
        handleError(
          "Apple Sign In failed. Please ensure Sign in with Apple is properly configured. Error: ${e.message ?? 'Unknown error (1000)'}",
          context,
        );
      } else {
        handleError("Apple Sign In failed: ${e.message ?? 'Unknown error'} (Code: ${e.code})", context);
      }
    } on PlatformException catch (e) {
      _handlePlatformException(context, e);
    } catch (e, s) {
      logger.e('error---> $e ----> stack --> $s');
      handleError(e is String ? e : e.toString(), context);
    } finally {
      setStatus(DataFetchStatus.initial);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // Apple Sign In doesn't require explicit logout like Facebook
      // Just clear local data and Firebase sign out
      await FirebaseAuth.instance.signOut();

      await _sharedPrefs.setStringPref(AppConstants.accessToken, "");
      await _sharedPrefs.setStringPref(AppConstants.refreshToken, "");
      await _sharedPrefs.setStringPref(AppConstants.userInfo, "");
      await _sharedPrefs.setBoolPref(AppConstants.logged, false);
      await _sharedPrefs.setBoolPref(AppConstants.parentDashboardLogged, false);
      _userData = null;

      // Reset AuthState
      authState.clear();
      ChildLocalStorage.clear();
      ParentLocalStorage.clear();
      _sharedPrefs.clear();

      setStatus(DataFetchStatus.initial);
      notifyListeners();
      if (!context.mounted) return;
      showCustomToaster("Signed out successfully.");
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.onboardingScreen,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      showCustomToaster("Failed to sign out.", isError: true);
    }
  }

  void onNavigate(context) {
    Utility.navigate(context, AppRoutes.dashboardScreen);
  }

  void _handlePlatformException(BuildContext context, PlatformException e) {
    String message = "An error occurred: ${e.message}";
    handleError(message, context);
  }

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  void handleError(String msg, context) {
    return showCustomToaster(msg, isError: true);
  }
}
```

---

## Step 6: Update Constants and Enums

### 6.1 Update `lib/src/core/constants/app_constants.dart`

Add Apple constant:

```dart
// Login Types
static const String email = 'email';
static const String google = 'google';
static const String apple = 'apple';  // Add this
// Remove: static const String facebook = 'facebook';
```

### 6.2 Update `lib/src/core/enums/app_enums.dart`

The enum already has `apple`:
```dart
enum AuthProviderType { google, apple, facebook, email, anonymous }
```

Keep `facebook` for backward compatibility with existing users, or remove if you want to fully deprecate.

---

## Step 7: Update Provider Configuration

### 7.1 Update `lib/src/config/provider_config.dart`

Add Apple Auth Provider:

```dart
// Add import
import '../provider/auth/aauth_provider.dart';

// Add provider instance
static final AAuthProvider appleAuthProvider = AAuthProvider(
  authState: authState,
);

// Add to providers list
ChangeNotifierProvider<AAuthProvider>(create: (_) => appleAuthProvider),
```

### 7.2 Update `lib/src/provider/provider.dart`

Add export:
```dart
export 'auth/aauth_provider.dart'; // Apple
```

---

## Step 8: Update UI Components

### 8.1 Update Login Screen

In `lib/src/screen/auth/login/login_screen.dart`:

Replace Facebook button with Apple button:

```dart
// Remove Facebook button
// ReusableWidget.horizontalIconTitle(
//   title: 'Continue with Facebook',
//   icon: Assets.facebook,
//   onTap: () async {
//     final facebookAuthProvider = context.read<FAuthProvider>();
//     await facebookAuthProvider.signInWithFacebook(context);
//   },
// ),

// Add Apple button
ReusableWidget.horizontalIconTitle(
  title: 'Continue with Apple',
  icon: Assets.apple, // You'll need to add Apple icon asset
  onTap: () async {
    final appleAuthProvider = context.read<AAuthProvider>();
    await appleAuthProvider.signInWithApple(context);
  },
),
```

### 8.2 Update Registration Screen

In `lib/src/screen/auth/register/widget/rs_4.dart`:

Replace Facebook button with Apple button (same pattern as login screen).

### 8.3 Add Apple Icon Asset

Add Apple logo SVG/PNG to `assets/svg/icons/` or `assets/images/` and update `lib/src/core/constants/assets.dart`:

```dart
static String apple = 'apple'.icon; // or path to asset
```

---

## Step 9: Update Utility Functions

### 9.1 Update `lib/src/core/utils/utility.dart`

Update the `getAuthProviderType` function to handle Apple:

```dart
// In the switch statement, add:
case AppConstants.apple:
  type = AuthProviderType.apple;
  break;
```

Update navigation logic if needed.

---

## Step 10: Handle User Data Migration (Optional)

If you want to migrate existing Facebook users:

1. Add a migration script to check for users with `auth_provider: 'facebook'`
2. Allow them to link Apple account or keep using Facebook
3. Or force migration with user notification

---

## Step 11: Setup Verification Checklist

### 11.1 Code Configuration Status ✅

All code-level configurations are complete:

- ✅ **Package Dependency**: `sign_in_with_apple: ^6.1.3` added in `pubspec.yaml`
- ✅ **iOS Entitlements**: `RunnerProfile.entitlements` contains `com.apple.developer.applesignin`
- ✅ **Xcode Project**: Entitlements linked for all build configurations (Debug, Release, Profile)
- ✅ **Flutter Implementation**: `AAuthProvider` created and registered
- ✅ **Error Handling**: Specific handling for error 1000 (unknown error)
- ✅ **UI Integration**: Apple Sign In buttons in login and registration screens
- ✅ **Bundle Identifier**: `fun.onepali.app` (consistent across configurations)

### 11.2 Manual Verification Required

#### Apple Developer Portal
1. **App ID Configuration**
   - [ ] Log in to [Apple Developer Portal](https://developer.apple.com/account/)
   - [ ] Navigate to **Certificates, Identifiers & Profiles** → **Identifiers**
   - [ ] Find App ID: `fun.onepali.app`
   - [ ] Verify **Sign in with Apple** capability is **enabled**
   - [ ] If not enabled, enable it and save

2. **Provisioning Profile**
   - [ ] Navigate to **Profiles** section
   - [ ] Note: If using **Automatic Signing** in Xcode, profiles are managed automatically
   - [ ] Xcode will automatically regenerate expired profiles when you build
   - [ ] For **Manual Signing**: Regenerate profile after enabling capability in App ID
   - [ ] Download and install updated profile if using manual signing

#### Firebase Console
1. **Firebase Authentication**
   - [ ] Go to [Firebase Console](https://console.firebase.google.com/)
   - [ ] Select your project
   - [ ] Navigate to **Authentication** → **Sign-in method**
   - [ ] Verify **Apple** provider is **enabled**
   - [ ] If not enabled, enable it (no additional configuration needed for iOS)

#### Xcode Project (Visual Verification)
1. **Open Xcode**
   - [ ] Open `ios/Runner.xcworkspace` (NOT .xcodeproj)
   - [ ] Select **Runner** target
   - [ ] Go to **Signing & Capabilities** tab
   - [ ] Verify **Sign in with Apple** capability is listed
   - [ ] If not visible, click **+ Capability** and add it
   - [ ] Verify **Team** is set correctly (`MT67ZHLR49`)
   - [ ] Verify **Bundle Identifier** is `fun.onepali.app`
   - [ ] Verify **Automatically manage signing** is checked (recommended)

2. **Build Settings Verification**
   - [ ] Go to **Build Settings** tab
   - [ ] Search for "Code Signing Entitlements"
   - [ ] Verify it shows `Runner/RunnerProfile.entitlements` for all configurations

### 11.3 Testing Checklist

- [ ] Test Apple Sign In on **physical iOS device** (required - doesn't work in simulator)
- [ ] Use Apple ID with **Two-Factor Authentication enabled**
- [ ] Test first-time user registration flow
- [ ] Test existing user login flow
- [ ] Test sign out functionality
- [ ] Verify Firestore user document creation/update
- [ ] Verify SharedPreferences data storage
- [ ] Test error handling (user cancellation, network errors)
- [ ] Test on different iOS versions (iOS 13+ required)
- [ ] Verify FCM token saving
- [ ] Test navigation after successful login

### 11.4 Provisioning Profile Management

**Automatic Signing (Recommended):**
- Xcode automatically manages provisioning profiles
- When you build, Xcode will:
  - Detect expired profiles and create new ones
  - Include new capabilities (like Sign in with Apple)
  - Download and install profiles automatically
- No manual intervention needed

**Manual Signing:**
- If profile is expired, regenerate it in Apple Developer Portal
- After enabling Sign in with Apple capability, regenerate profile to include it
- Download and install the new profile in Xcode

---

## Step 12: Remove Facebook Dependencies (Optional)

If completely removing Facebook:

### 12.1 Remove Package

From `pubspec.yaml`:
```yaml
# Remove: flutter_facebook_auth: ^7.1.2
```

### 12.2 Remove Provider

- Delete `lib/src/provider/auth/fauth_provider.dart`
- Remove from `provider_config.dart`
- Remove from `provider.dart` exports

### 12.3 Remove Assets

- Remove Facebook icon assets
- Update onboarding screens if they mention Facebook

### 12.4 Update Constants

- Remove `facebook` from `AppConstants`
- Remove `facebook` from `AuthProviderType` enum (or keep for backward compatibility)

---

## Important Notes

1. **iOS Only**: Sign in with Apple is primarily for iOS. For Android, you'll need a different approach or use Firebase's web-based Apple Sign In.

2. **User Privacy**: Apple Sign In may not always provide email on subsequent logins. Handle cases where email might be missing.

3. **Name Handling**: Apple only provides full name on first sign-in. Store it in Firestore for future use.

4. **App Store Requirement**: If your app offers third-party login (Google), Apple requires you to also offer Sign in with Apple.

5. **Testing**: Apple Sign In requires a real iOS device - it doesn't work in the iOS Simulator.

6. **Backward Compatibility**: Consider keeping Facebook login code for existing users, or implement a migration strategy.

---

## Troubleshooting

### Common Issues

1. **Error 1000 (Unknown Error) - "The operation could not be completed. (com.apple.AuthenticationServices.AuthorizationError error 1000.)"**
   
   **Possible Causes:**
   - Capability not enabled in Apple Developer Portal
   - Provisioning profile doesn't include capability
   - Entitlements not linked in Xcode project (✅ Fixed - now linked for all build configurations)
   - Testing on simulator (won't work - requires physical device)
   - 2FA not enabled on Apple ID
   - Expired provisioning profile (Xcode will auto-update if using Automatic Signing)
   
   **Solution Steps:**
   1. Verify Sign in with Apple is enabled in Apple Developer Portal for App ID
   2. If using Automatic Signing, clean build folder (Cmd+Shift+K) and rebuild - Xcode will regenerate profile
   3. If using Manual Signing, regenerate provisioning profile in Apple Developer Portal
   4. Ensure testing on physical iOS device (not simulator)
   5. Verify user's Apple ID has Two-Factor Authentication enabled
   6. Check error logs for specific error code and message

2. **"Sign in with Apple capability not found"**
   - Verify capability is added in Xcode (Signing & Capabilities tab)
   - Check provisioning profile includes the capability
   - Verify entitlements file is linked in all build configurations

3. **"Invalid client" error**
   - Verify Firebase Apple provider is enabled in Firebase Console
   - Check bundle identifier matches Apple Developer App ID
   - Ensure `GoogleService-Info.plist` is up to date

4. **Email not provided**
   - Apple may hide email - handle gracefully
   - Use Firebase user email as fallback
   - Code already handles this with: `appleCredential.email ?? firebaseUser?.email ?? ''`

5. **Name not provided on subsequent logins**
   - Apple only provides full name on first sign-in
   - Code stores name in Firestore on first login
   - Use stored name from Firestore for subsequent logins

6. **Expired Provisioning Profile**
   - **Automatic Signing**: Xcode will automatically create new profile when you build
   - **Manual Signing**: Regenerate profile in Apple Developer Portal
   - After regenerating, download and install in Xcode
   - Clean build folder (Cmd+Shift+K) after updating profile

---

## References

- [sign_in_with_apple Package](https://pub.dev/packages/sign_in_with_apple)
- [Firebase Apple Authentication](https://firebase.google.com/docs/auth/ios/apple)
- [Apple Sign In Documentation](https://developer.apple.com/sign-in-with-apple/)

---

## Migration Timeline

1. **Phase 1**: Add Apple Sign In alongside Facebook (Week 1)
2. **Phase 2**: Test thoroughly (Week 2)
3. **Phase 3**: Update UI to show Apple instead of Facebook (Week 3)
4. **Phase 4**: Monitor usage and deprecate Facebook (Week 4+)

