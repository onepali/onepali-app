# Apple Sign In Auth Status

This document records the current Apple Sign In setup and the Facebook auth
cleanup state for the O Nepali app.

## Current Auth Providers

The app currently supports:

- Apple Sign In via `sign_in_with_apple`
- Google Sign In via `google_sign_in`
- Email/password via Firebase Auth

Facebook auth is no longer an active auth provider.

## Current Apple Sign In Wiring

Apple Sign In is wired through:

- `pubspec.yaml`: `sign_in_with_apple`
- `lib/src/provider/auth/aauth_provider.dart`: Apple auth provider
- `lib/src/provider/provider.dart`: Apple provider export
- `lib/src/config/provider_config.dart`: `AAuthProvider` registration
- `lib/src/screen/auth/login/login_screen.dart`: Apple login button
- `lib/src/screen/auth/register/widget/rs_4.dart`: Apple registration button
- `lib/src/core/constants/app_constants.dart`: `AppConstants.apple`
- `lib/src/core/enums/app_enums.dart`: `AuthProviderType.apple`
- `ios/Runner/RunnerProfile.entitlements`: Sign in with Apple entitlement

## Required External Configuration

These settings are outside the repo and must be verified in Apple/Firebase
accounts:

- Apple Developer App ID `fun.onepali.app` has Sign in with Apple enabled.
- The iOS provisioning profile includes the Sign in with Apple capability.
- Firebase Authentication has the Apple provider enabled.
- `ios/GoogleService-Info.plist` matches the Firebase project used by the app.

## Facebook Auth Cleanup

Facebook auth has been removed from active app wiring:

- `flutter_facebook_auth` removed from `pubspec.yaml` and `pubspec.lock`
- `lib/src/provider/auth/fauth_provider.dart` deleted
- Facebook provider export removed from `lib/src/provider/provider.dart`
- Facebook auth provider test deleted
- Android Facebook manifest/resources removed
- iOS Facebook plist/app delegate entries removed
- Generated plugin registrants refreshed

Remaining Facebook text that is not auth:

- `lib/src/core/model/onboard/onboard_model.dart` has
  `Facebook / Instagram` as an onboarding discovery-source option using the
  Meta icon.

## Verification

Run these after auth dependency or native configuration changes:

```bash
flutter pub get
flutter analyze --fatal-warnings
flutter test
flutter build apk --debug
flutter build web
```

iOS simulator builds should be verified in CI with a runner that has a new
enough Xcode/iOS SDK for current plugin dependencies. The workflow currently
uses `macos-26` and prints `xcodebuild -version` for traceability.

Manual Apple Sign In verification should be done on an iOS device or supported
simulator with a real Apple ID and two-factor authentication enabled.
