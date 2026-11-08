
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';

class ScamShieldApp extends StatelessWidget {
  const ScamShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      initialRoute: AppConstants.splashRoute,

      routes: {
        AppConstants.splashRoute: (context) =>
            const SplashScreen(),

        AppConstants.homeRoute: (context) =>
            const HomeScreen(),
      },
    );
  }
}
