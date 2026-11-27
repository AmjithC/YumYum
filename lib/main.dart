import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'services/cart_provider.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: defaultTargetPlatform == TargetPlatform.android
        ? null
        : DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const YumQuickApp(),
    ),
  );
}

class YumQuickApp extends StatelessWidget {
  const YumQuickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YumQuick',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SplashScreen(),
    );
  }
}
