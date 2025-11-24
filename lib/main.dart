import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();

  // await dotenv.load(fileName: AppConstants.dotEnvFileName);
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
