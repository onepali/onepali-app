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

  /// Returns error message if invalid, null if valid.
  /// Validates name to contain only letters, spaces, and common name characters.
  static String? name(String name) {
    if (name.trim().isEmpty) return "Name is required";

    // Allow only letters (including Unicode letters for international names),
    // spaces, hyphens, and apostrophes
    final RegExp nameRegex = RegExp(r"^[\p{L}\s\-']+$", unicode: true);

    if (!nameRegex.hasMatch(name.trim())) {
      return "Name can only contain letters, spaces, hyphens and apostrophes";
    }

    // Check for consecutive spaces or special characters
    if (name.trim().contains(RegExp(r'\s{2,}'))) {
      return "Name cannot contain consecutive spaces";
    }

    // Check minimum length
    if (name.trim().length < 2) {
      return "Name must be at least 2 characters long";
    }

    return null;
  }
}
