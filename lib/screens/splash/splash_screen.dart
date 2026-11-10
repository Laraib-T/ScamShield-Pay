import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../auth/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF17111D),
                    Color(0xFF261C30),
                    Color(0xFF35233F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final logoSize = (constraints.maxWidth * 0.58).clamp(
                150.0,
                220.0,
              );

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),
                      Image.asset(
                        'assets/images/logo.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'ScamShield Pay',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.darkPurple,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Let AI check before you pay',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white70 : AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF493052)
                              : Colors.white.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'SMART  •  SAFE  •  SECURE',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF7041A5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
                      const CircularProgressIndicator(
                        color: AppColors.softPurple,
                        strokeWidth: 2.5,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
