import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricraft/theme/app_theme.dart';
import 'package:nutricraft/screens/splash_screen.dart';

import 'package:nutricraft/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
 
  
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
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'NutriCraft',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
