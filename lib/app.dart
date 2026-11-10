import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/constants/app_constants.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';

class ScamShieldApp extends StatefulWidget {
  const ScamShieldApp({super.key});

  @override
  State<ScamShieldApp> createState() => _ScamShieldAppState();
}

class _ScamShieldAppState extends State<ScamShieldApp> {
  final ThemeController themeController = ThemeController.instance;

  @override
  void initState() {
    super.initState();
    themeController.addListener(updateTheme);
    themeController.loadTheme();
  }

  void updateTheme() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    themeController.removeListener(updateTheme);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      initialRoute: AppConstants.splashRoute,
      routes: {
        AppConstants.splashRoute: (context) => const SplashScreen(),
        AppConstants.homeRoute: (context) => const HomeScreen(),
      },
    );
  }
}
