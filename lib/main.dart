import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();

  await dotenv.load(fileName: AppConstants.dotEnvFileName);
  await AppInitializer().initializeApp();

  runApp(
    MultiProvider(
      providers: ProviderConfig.providers,
      child: MyApp(logged: await AppInitializer.checkUserAuthentication()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool logged;
  const MyApp({super.key, required this.logged});

  @override
  Widget build(BuildContext context) {
    return AppInitializer.appMaterialApp(context, logged);
  }
}
