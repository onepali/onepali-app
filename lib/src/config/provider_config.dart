import 'package:provider/provider.dart';

import '../src.dart';

class ProviderConfig {
  /// [System] Provider
  static final SystemProvider systemProvider = SystemProvider();

  /// [User] Provider
  static final UserProvider userProvider = UserProvider();

  /// [Lesson] Provider
  static final LessonProvider lessonProvider = LessonProvider();

  //* --------------------------- End --------------------------- *//

  static final List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<SystemProvider>(create: (_) => systemProvider),
    ChangeNotifierProvider<UserProvider>(create: (_) => userProvider),
    ChangeNotifierProvider<LessonProvider>(create: (_) => lessonProvider),
  ];

  /// Dispose all providers
  static void dispose() {
    systemProvider.dispose();
    userProvider.dispose();
    lessonProvider.dispose();
  }

  /// Singleton factory
  static final ProviderConfig _instance = ProviderConfig._internal();

  factory ProviderConfig() {
    return _instance;
  }

  ProviderConfig._internal();
}
