import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../src/src.dart';

import '../../navigator_key.dart';
import 'package:provider/provider.dart';

class AppInitializer {
  Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Lock orientation to landscape mode
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    HttpOverrides.global = MyHttpOverrides();
  }

  static Widget appMaterialApp(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      initialRoute: AppRoutes.splashScreen,
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
