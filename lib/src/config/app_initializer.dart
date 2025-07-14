import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    WidgetsFlutterBinding.ensureInitialized();
    ConnectivityService().startListening();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    HttpOverrides.global = MyHttpOverrides();
    await NotificationService.initialize();
    tz.initializeTimeZones();
    final String deviceTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(deviceTimeZone));

    await ProviderConfig.pzNotificationProvider.getNotificationSetting();
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
    var logged = await ParentLocalStorage.isParentLogged();
    return logged;
  }

  static String getInitialRoute(bool logged, bool isParentLogged) {
    if (!logged) return AppRoutes.splashScreen;
    if (isParentLogged) return AppRoutes.parentDashboardScreen;
    return AppRoutes.dashboardScreen;
  }

  // // Function to check screen time after app loads
  // static void checkScreenTimeAfterBoot() async {
  //   // We'll call this after the app starts
  //   try {
  //     final currentChildId = await ChildLocalStorage.getCurrentChildId();
  //     if (currentChildId != null) {
  //       logger.i(
  //         '🔍 Checking screen time limit for child $currentChildId on app start',
  //       );
  //       final isLimitExceeded = await ScreenTimeService.instance
  //           .checkScreenTimeLimitExceeded(currentChildId);

  //       if (isLimitExceeded) {
  //         logger.w(
  //           '⚠️ Screen time limit already exceeded for child $currentChildId on app start',
  //         );
  //         // Use navigatorKey to navigate to parent PIN screen
  //         navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //           AppRoutes.parentPinScreen,
  //           (route) => false,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     logger.e('Error checking screen time on app start: $e');
  //   }
  // }

  static Widget appMaterialApp(BuildContext context, logged, isParentLogged) {
    final initialRoute = getInitialRoute(logged, isParentLogged);

    // // Schedule the screen time check to run after app initializes
    // Misc.onLayoutRendered(() {
    //   if (logged && !isParentLogged) {
    //     checkScreenTimeAfterBoot();
    //   }
    // });

    return MaterialApp(
      title: AppConstants.appName,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      navigatorObservers: [OrientationRouteObserver()],
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
      theme: ThemeConfig.lightTheme,
      locale: context.watch<LanguageProvider>().locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ne')],
      onGenerateRoute: (settings) {
        WidgetBuilder? builder = AppRoutes.routes[settings.name];
        if (builder != null) {
          return PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => builder(context),
            settings: settings,
            transitionsBuilder: RouteAnimationBuilder.slideFromBottom,
            transitionDuration: const Duration(milliseconds: 400),
          );
        }
        return null;
      },
      builder:
          (context, widget) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1)),
            child: Material(child: widget),
          ),
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
