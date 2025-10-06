import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();

  // Configure system UI overlay for proper full-screen display
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Allow all orientations initially - let OrientationRouteObserver handle specific routes
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await dotenv.load(fileName: AppConstants.dotEnvFileName);
  await AppInitializer().initializeApp();

  final bool logged = await AppInitializer.checkUserAuthentication();
  final bool isParentLogged = await AppInitializer.isParentLogged();

  runApp(
    MultiProvider(
      providers: ProviderConfig.providers,
      child: MyApp(logged: logged, isParentLogged: isParentLogged),
    ),
  );
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
