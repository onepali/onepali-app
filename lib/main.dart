import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

void main() async {
  // Wrap everything in error handling to prevent white screen
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logger.e('Flutter error: ${details.exception}');
    logger.e('Stack trace: ${details.stack}');
  };

  // Handle platform errors
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e('Platform error: $error');
    logger.e('Stack trace: $stack');
    return true; // Return true to prevent app from crashing
  };

  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize SharedPreferences - critical for app state
    try {
      await SharedPreferencesService.init();
      logger.i('✅ SharedPreferences initialized');
    } catch (e) {
      logger.e('❌ SharedPreferences initialization failed: $e');
      // Continue anyway - some features may not work
    }

    // await dotenv.load(fileName: AppConstants.dotEnvFileName);
    
    // Initialize app - this now has internal error handling
    await AppInitializer().initializeApp();

    // Check authentication - handle errors gracefully
    bool logged = false;
    bool isParentLogged = false;
    try {
      logged = await AppInitializer.checkUserAuthentication();
      isParentLogged = await AppInitializer.isParentLogged();
      logger.d('Authentication check: logged=$logged, isParentLogged=$isParentLogged');
    } catch (e) {
      logger.w('⚠️ Authentication check failed, defaulting to logged out: $e');
      // Default to logged out state if check fails
    }

    runApp(
      MultiProvider(
        providers: ProviderConfig.providers,
        child: MyApp(logged: logged, isParentLogged: isParentLogged),
      ),
    );
  } catch (e, stackTrace) {
    logger.e('❌ Critical error in main(): $e');
    logger.e('Stack trace: $stackTrace');
    
    // Even if everything fails, try to show an error screen instead of white screen
    runApp(
      MaterialApp(
        title: 'O Nepali',
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'App initialization failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please restart the app',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final bool logged;
  final bool isParentLogged;
  const MyApp({super.key, required this.logged, required this.isParentLogged});

  @override
  Widget build(BuildContext context) {
    return AppInitializer.appMaterialApp(context, logged, isParentLogged);
  }
}
