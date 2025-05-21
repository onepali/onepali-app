import 'package:provider/provider.dart';

import '../src.dart';

class ProviderConfig {
  /// [System] Provider
  static final SystemProvider systemProvider = SystemProvider();
  static final SplashProvider splashProvider = SplashProvider();
  static final LanguageProvider languageProvider = LanguageProvider();

  /// [Auth] Provider
  static final AuthProvider authProvider = AuthProvider();

  /// [User] Provider
  static final UserProvider userProvider = UserProvider();

  /// [Lesson] Provider
  static final LessonProvider lessonProvider = LessonProvider();
  static final LessonAudioProvider lessonAudioProvider = LessonAudioProvider();

  //* --------------------------- End --------------------------- *//

  static final List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<SystemProvider>(create: (_) => systemProvider),
    ChangeNotifierProvider<SplashProvider>(create: (_) => splashProvider),
    ChangeNotifierProvider<LanguageProvider>(create: (_) => languageProvider),
    ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
    ChangeNotifierProvider<UserProvider>(create: (_) => userProvider),
    ChangeNotifierProvider<LessonProvider>(create: (_) => lessonProvider),
    ChangeNotifierProvider<LessonAudioProvider>(
      create: (_) => lessonAudioProvider,
    ),
  ];

  /// Dispose all providers
  static void dispose() {
    systemProvider.dispose();
    splashProvider.dispose();
    languageProvider.dispose();
    authProvider.dispose();
    userProvider.dispose();
    lessonProvider.dispose();
    lessonAudioProvider.dispose();
  }

  /// Singleton factory
  static final ProviderConfig _instance = ProviderConfig._internal();

  factory ProviderConfig() {
    return _instance;
  }

  ProviderConfig._internal();
}
