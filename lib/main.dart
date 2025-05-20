import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

import 'navigator_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: AppConstants.dotEnvFileName);
  await AppInitializer().initializeApp();

  runApp(MultiProvider(providers: ProviderConfig.providers, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            ResponsiveConfig().init(constraints, orientation);
            return MaterialApp(
              title: GlobalConfig.appName,
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: GlobalConfig.isShowDebugModeBanner,
              scrollBehavior: CustomScrollBehavior(),
              initialRoute: AppRoutes.splashScreen,
              routes: AppRoutes.routes,
              theme: ThemeConfig.lightTheme,
              onGenerateRoute: (settings) {
                WidgetBuilder? builder = AppRoutes.routes[settings.name];
                if (builder != null) {
                  return PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            builder(context),
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
          },
        );
      },
    );
  }
}
