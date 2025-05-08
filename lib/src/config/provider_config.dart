import 'package:provider/provider.dart';

class ProviderConfig {
  /// [System] Provider
  // static final SystemProvider systemProvider = SystemProvider();

  //* --------------------------- End --------------------------- *//

  static final List<ChangeNotifierProvider> providers = [
    // ChangeNotifierProvider<SystemProvider>(create: (_) => systemProvider),
  ];

  /// Dispose all providers
  static void dispose() {
    // systemProvider.dispose();
  }

  /// Singleton factory
  static final ProviderConfig _instance = ProviderConfig._internal();

  factory ProviderConfig() {
    return _instance;
  }

  ProviderConfig._internal();
}
