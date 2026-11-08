
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../results/results_screen.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    startAnalysis();
  }

  Future<void> startAnalysis() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ResultsScreen(),
      ),
    );
  }

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
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: AppColors.lavender,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    size: 65,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 30),

                const CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 4,
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

                const SizedBox(height: 25),

                const Text(
                  'Preview Mode: Live AI analysis is not connected yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
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
