import 'package:provider/provider.dart';

import '../src.dart';

class ProviderConfig {
  /// [System] Provider
  static final SystemProvider systemProvider = SystemProvider();
  static final SplashProvider splashProvider = SplashProvider();
  static final LanguageProvider languageProvider = LanguageProvider();

  /// [Auth] Provider
  static final AuthState authState = AuthState();
  static final AuthProvider authProvider = AuthProvider(authState: authState);
  static final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider(
    authState: authState,
  );
  static final FAuthProvider facebookAuthProvider = FAuthProvider(
    authState: authState,
  );
  static final ChildAuthProvider childAuthProvider = ChildAuthProvider();

  /// [User] Provider
  static final UserProvider userProvider = UserProvider();

  /// [Lesson] Provider
  static final LessonProvider lessonProvider = LessonProvider();
  static final LessonAudioProvider lessonAudioProvider = LessonAudioProvider();

  /// [Child] Provider
  static final ChildUserProvider childUserProvider = ChildUserProvider();

  /// [Song] Provider
  static final SongProvider songProvider = SongProvider();

  /// [Recommended] Provider
  static final RcmSongProvider recommendedSongProvider = RcmSongProvider();
  static final RecommendedStoryProvider recommendedStoryProvider =
      RecommendedStoryProvider();
  static final RecommendedLessonProvider recommendedLessonProvider =
      RecommendedLessonProvider();

  /// [Story] Provider
  static final StoryProvider storyProvider = StoryProvider();

  //* --------------------------- End --------------------------- *//

  static final List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<AuthState>(create: (_) => authState),
    ChangeNotifierProvider<SystemProvider>(create: (_) => systemProvider),
    ChangeNotifierProvider<SplashProvider>(create: (_) => splashProvider),
    ChangeNotifierProvider<LanguageProvider>(create: (_) => languageProvider),
    ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
    ChangeNotifierProvider<GoogleAuthProvider>(
      create: (_) => googleAuthProvider,
    ),
    ChangeNotifierProvider<FAuthProvider>(create: (_) => facebookAuthProvider),
    ChangeNotifierProvider<ChildAuthProvider>(create: (_) => childAuthProvider),
    ChangeNotifierProvider<UserProvider>(create: (_) => userProvider),
    ChangeNotifierProvider<LessonProvider>(create: (_) => lessonProvider),
    ChangeNotifierProvider<LessonAudioProvider>(
      create: (_) => lessonAudioProvider,
    ),

    /// [Child] Providers -------------------------------- *//
    ChangeNotifierProvider<ChildUserProvider>(create: (_) => childUserProvider),

    ChangeNotifierProvider<SongProvider>(create: (_) => songProvider),
    ChangeNotifierProvider<RcmSongProvider>(
      create: (_) => recommendedSongProvider,
    ),
    ChangeNotifierProvider<RecommendedStoryProvider>(
      create: (_) => recommendedStoryProvider,
    ),
    ChangeNotifierProvider<RecommendedLessonProvider>(
      create: (_) => recommendedLessonProvider,
    ),
    ChangeNotifierProvider<StoryProvider>(create: (_) => storyProvider),
  ];

  /// Dispose all providers
  static void dispose() {
    systemProvider.dispose();
    splashProvider.dispose();
    authProvider.dispose();
    googleAuthProvider.dispose();
    facebookAuthProvider.dispose();
    childAuthProvider.dispose();
    languageProvider.dispose();
    userProvider.dispose();
    lessonProvider.dispose();
    lessonAudioProvider.dispose();

    childUserProvider.dispose();
    recommendedSongProvider.dispose();
    recommendedStoryProvider.dispose();
    recommendedLessonProvider.dispose();
    songProvider.dispose();
  }

  /// Singleton factory
  static final ProviderConfig _instance = ProviderConfig._internal();

  factory ProviderConfig() {
    return _instance;
  }

  ProviderConfig._internal();
}
