import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../src/src.dart';

import '../../navigator_key.dart';
import 'package:provider/provider.dart';

class AppInitializer {
  Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
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

  static Widget appMaterialApp(BuildContext context, logged, isParentLogged) {
    return MaterialApp(
      title: AppConstants.appName,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      navigatorObservers: [OrientationRouteObserver()],
      initialRoute: getInitialRoute(logged, isParentLogged),
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
