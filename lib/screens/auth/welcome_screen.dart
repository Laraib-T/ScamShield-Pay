import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/gradient_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.darkPurple;
    final subtitleColor = isDark ? Colors.white70 : AppColors.textGrey;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 42,
                    width: 42,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF35233F), Color(0xFF493052)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFEFE4FF), Color(0xFFF8F2FF)],
                        ),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 25,
                      right: 35,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 28,
                        color: AppColors.softPurple,
                      ),
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 190,
                      width: 190,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      bottom: 22,
                      left: 30,
                      child: Icon(
                        Icons.verified_rounded,
                        color: AppColors.softPurple,
                        size: 25,
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      right: 35,
                      child: Icon(
                        Icons.auto_awesome,
                        color: AppColors.softPurple,
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Shop Smart.\nPay Safe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 34,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Check sellers, detect suspicious listings, '
                'and protect your payments with AI.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 35),
              GradientButton(
                text: 'Create Account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.softPurple,
                    side: const BorderSide(
                      color: AppColors.softPurple,
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Your safety comes first.',
                style: TextStyle(color: subtitleColor, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
