import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onepali/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../src/src.dart';

import '../../navigator_key.dart';
import 'package:provider/provider.dart';

class AppInitializer {
  Future<void> initializeApp() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      ConnectivityService().startListening();

      // Firebase initialization - critical, but handle errors gracefully
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        logger.i('✅ Firebase initialized successfully');
      } catch (e) {
        logger.e('❌ Firebase initialization failed: $e');
        // Don't rethrow - try to continue without Firebase
        // Some features may not work, but app should still launch
      }

      // App Check - non-critical, don't block app launch
      try {
        await AppCheckUtil.initialize();
      } catch (e) {
        logger.w('⚠️ App Check initialization failed, continuing: $e');
      }

      HttpOverrides.global = MyHttpOverrides();

      // Notification service - handle errors gracefully
      if (!kIsWeb) {
        try {
          await NotificationService.initialize();
          logger.i('✅ Notification service initialized');
        } catch (e) {
          logger.w(
            '⚠️ Notification service initialization failed, continuing: $e',
          );
        }
      }

      // Timezone initialization - handle errors gracefully
      try {
        tz.initializeTimeZones();
        final TimezoneInfo deviceTimeZone =
            await FlutterTimezone.getLocalTimezone();
        final String timezoneIdentifier = deviceTimeZone.identifier;
        final String fixedTimeZone = timezoneIdentifier == 'Asia/Katmandu'
            ? 'Asia/Kathmandu'
            : timezoneIdentifier;
        logger.d(
          'Device Timezone: $timezoneIdentifier, Fixed Timezone: $fixedTimeZone',
        );
        tz.setLocalLocation(tz.getLocation(fixedTimeZone));
        logger.i('✅ Timezone initialized successfully');
      } catch (e) {
        logger.w('⚠️ Timezone initialization failed, using default: $e');
        // Set a default timezone if initialization fails
        try {
          tz.setLocalLocation(tz.getLocation('UTC'));
        } catch (_) {
          // If even UTC fails, just continue without timezone
        }
      }

      // Initialize guest user status
      try {
        await GuestUtil.init();
        logger.i('✅ Guest utilities initialized');
      } catch (e) {
        logger.w('⚠️ Guest utilities initialization failed, continuing: $e');
      }

      logger.i('✅ App initialization completed');
    } catch (e, stackTrace) {
      logger.e('❌ Critical error during app initialization: $e');
      logger.e('Stack trace: $stackTrace');
      // Don't rethrow - let the app try to launch anyway
      // This prevents white screen of death
    }
  }

  static Future<bool> checkUserAuthentication() async {
    final SharedPreferencesService sharedPref = SharedPreferencesService();
    var logged = await sharedPref.getBoolPref(AppConstants.logged);
    var userInfo = await sharedPref.getStringPref(AppConstants.userInfo);
    logger.d(
      'User logged: $logged, User info: $userInfo && ${userInfo != null}',
    );

    return logged && userInfo != null;
  }

  static Future<bool> isParentLogged() async {
    final SharedPreferencesService sharedPref = SharedPreferencesService();
    var loggedIn = await sharedPref.getBoolPref(AppConstants.logged);
    var userInfo = await sharedPref.getStringPref(AppConstants.userInfo);
    var logged = await ParentLocalStorage.isParentLogged();

    logger.d(
      'Parent logged: $loggedIn, User info: $userInfo && ${userInfo != null}, Parent logged status: $logged',
    );
    return loggedIn && userInfo != null && logged;
  }

  static String getInitialRoute(bool logged, bool isParentLogged) {
    if (!logged) return AppRoutes.splashScreen;
    if (isParentLogged) return AppRoutes.parentDashboardScreen;

    logger.d(
      'User is logged in---> $logged, Parent logged in---> $isParentLogged',
    );
    return AppRoutes.dashboardScreen;
  }

  /// Set initial orientation based on the initial route
  static Future<void> setInitialRouteOrientation(String initialRoute) async {
    // Check if initial route should be portrait
    final portraitRoutes = OrientationRouteObserver.portraitRoutes;
    final shouldBePortrait = portraitRoutes.contains(initialRoute);

    // Use "allow all then lock" pattern for better reliability
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Future.delayed(const Duration(milliseconds: 100));

    if (shouldBePortrait) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    logger.d(
      '🔒 Initial orientation set: ${shouldBePortrait ? "PORTRAIT" : "LANDSCAPE"} '
      'for route: $initialRoute',
    );
  }

  static Widget appMaterialApp(BuildContext context, logged, isParentLogged) {
    final initialRoute = getInitialRoute(logged, isParentLogged);

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            try {
              ResponsiveConfig().init(constraints, orientation);
            } catch (e) {
              logger.w('⚠️ ResponsiveConfig initialization failed: $e');
              // Continue with default values
            }

            // Safely get locale from Provider, with fallback
            Locale appLocale;
            try {
              appLocale = context.watch<LanguageProvider>().locale;
            } catch (e) {
              logger.w(
                '⚠️ Failed to get locale from LanguageProvider, using default: $e',
              );
              appLocale = const Locale('en'); // Default fallback
            }

            return MaterialApp(
              title: AppConstants.appName,
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              scrollBehavior: CustomScrollBehavior(),
              navigatorObservers: [OrientationRouteObserver()],
              initialRoute: initialRoute,
              routes: AppRoutes.routes,
              theme: ThemeConfig.lightTheme,
              locale: appLocale,
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('ne')],
              onGenerateRoute: (settings) {
                try {
                  WidgetBuilder? builder = AppRoutes.routes[settings.name];
                  if (builder != null) {
                    return PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          builder(context),
                      settings: settings,
                      transitionsBuilder: RouteAnimationBuilder.slideFromBottom,
                      transitionDuration: const Duration(milliseconds: 400),
                    );
                  }
                } catch (e) {
                  logger.e('❌ Error generating route for ${settings.name}: $e');
                }
                return null;
              },
              builder: (context, widget) {
                // Wrap in error boundary to catch any widget build errors
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1)),
                  child: Material(
                    child:
                        widget ??
                        const Center(child: CircularProgressIndicator()),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return kDebugMode ? true : false;
      };
  }
}
