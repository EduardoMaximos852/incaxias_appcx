import 'package:flutter/material.dart';
import 'package:incaxias_appcx/routes/routes.dart';
import 'package:incaxias_appcx/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const IncaxiasApp());
}

class IncaxiasApp extends StatelessWidget {
  const IncaxiasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaxiasApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
