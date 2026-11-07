import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shield_rounded,
                  size: 75,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 25),

                const CircularProgressIndicator(
                  color: AppColors.primary,
                ),

                const SizedBox(height: 30),

                const Text(
                  'Analyzing...',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPurple,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Please wait while we prepare your security report.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}