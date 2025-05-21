import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:nutricraft/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notifications
 
  
  runApp(
    const ProviderScope(
      child: NutriCraftApp(),
    ),
  );
}

class NutriCraftApp extends ConsumerWidget {
  const NutriCraftApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'NutriCraft',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
