// Svg Source
enum SvgSourceType { asset, network }

// Lottie Source
enum LottieSourceType { asset, network }

// Image Source
enum CustomImageType { local, network }

// Data Fetch Status
enum DataFetchStatus { initial, loading, success, error }

// Log Level
enum LogLevel { debug, info, warning, error, success }

// Auth Provider
enum AuthProviderType { google, apple, facebook, email, anonymous }

// Audio Source
enum AudioSourceType { asset, network }

// Video Source
enum VideoSourceType { asset, network }

// Network Type
enum NetworkType { none, wifi, mobile, ethernet, bluetooth, vpn, other, satellite }

enum DeviceType { mobile, tablet, desktop, watch }

enum RefinedSize { small, normal, large, extraLarge }

enum RefinedOrientation { portrait, landscape }

// Passcode Screen States
enum PasscodeScreenState {
  loading, // Initial check for existing passcode
  setNewPasscode, // First time setup - enter new passcode
  confirmPasscode, // Confirm new passcode
  enterPasscode, // Normal verification
  resetPasscode, // Reset flow using date of birth
  resetSetNew, // After successful reset, set new passcode
  resetConfirm, // Confirm new passcode after reset
}

// Passcode Modes
enum PasscodeMode {
  digits4, // 4-digit PIN
  digits6, // 6-digit PIN
}
