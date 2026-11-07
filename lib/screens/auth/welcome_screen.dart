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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const SizedBox(height: 35),

              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.shield_rounded,
                      color: AppColors.primary,
                      size: 30,
                    ),
                    SizedBox(width: 9),
                    Text(
                      AppConstants.appName,
                      style: TextStyle(
                        color: AppColors.darkPurple,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 55),

              Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lavender.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 22,
                      right: 35,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 30,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                    Container(
                      height: 135,
                      width: 135,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.12),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        size: 82,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 22,
                      left: 35,
                      child: Icon(
                        Icons.lock_rounded,
                        color: AppColors.darkPurple.withOpacity(0.6),
                        size: 28,
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      right: 40,
                      child: Icon(
                        Icons.favorite_rounded,
                        color: AppColors.danger.withOpacity(0.7),
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'Shop Smart.\\nPay Safe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.darkPurple,
                  fontSize: 34,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Check sellers, detect suspicious listings, '
                'and protect your payments with AI.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 38),

              GradientButton(
                text: 'Create Account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
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
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Your safety comes first.',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}