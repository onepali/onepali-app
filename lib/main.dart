import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: AppConstants.dotEnvFileName);
  await AppInitializer().initializeApp();

  runApp(
    MultiProvider(providers: ProviderConfig.providers, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppInitializer.appMaterialApp(context);
  }
}
