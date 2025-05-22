class Validator {
  /// Returns error message if invalid, null if valid.
  static String? email(String email) {
    if (email.trim().isEmpty) return "Email is required";
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) return "Enter a valid email address";
    return null;
  }

  /// Validate if the given string is a valid phone number.
  static bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  /// Validate if the given string is a valid URL.
  static bool isValidURL(String url) {
    final RegExp urlRegex = RegExp(
      r'^(https?:\/\/)?([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,})([\/\w .-]*)*\/?$',
    );
    return urlRegex.hasMatch(url);
  }

  /// Returns error message if invalid, null if valid.
  static String? password(String password) {
    if (password.trim().isEmpty) return "Password is required";
    // No complexity requirements for child & parent app
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  static String? empty(String value) {
    return value.trim().isEmpty ? "This field is required" : null;
  }
}
