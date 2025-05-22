class AppConstants {
  static const String appName = 'O Nepali';
  static const String appVersion = 'v1.0.0';
  static const String defaultFontFamily = 'Poppins';

  static const String dotEnvFileName = '.env';
  static const String defaultLanguageCode = 'en';

  // Login Types
  static const String email = 'email';
  static const String google = 'google';
  static const String facebook = 'facebook';

  // Shared Preferences Keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userInfo = 'user_info';
  static const String logged = 'logged';

  static List<String> whyLearningNepali = [
    'Develop a learning habit',
    'Communicate with relatives in Nepal',
    'Build vocabulary',
    'Daily conversation',
  ];

  static List<Map<String, dynamic>> languages = [
    {'code': 'en', 'name': 'English', 'flag': 'assets/images/flags/en.png'},
    {'code': 'ne', 'name': 'नेपाली', 'flag': 'assets/images/flags/ne.png'},
  ];
}
