import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../home/home_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController blinkController;

  String riskLevel = 'Uncertain';

  @override
  void initState() {
    super.initState();

    blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    blinkController.dispose();
    super.dispose();
  }

  Color get activeColor {
    if (riskLevel == 'High') return Colors.red;
    if (riskLevel == 'Medium') return Colors.amber;
    if (riskLevel == 'Low') return Colors.green;
    return Colors.blueGrey;
  }

  Widget trafficLight(String level, Color color) {
    final bool isActive = riskLevel == level;

    return AnimatedBuilder(
      animation: blinkController,
      builder: (context, child) {
        final double opacity = isActive
            ? 0.45 + (blinkController.value * 0.55)
            : 0.15;

        return Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: opacity),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(
                        alpha: 0.3 + blinkController.value * 0.5,
                      ),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            Icons.circle,
            color: isActive
                ? Colors.white.withValues(
                    alpha: 0.5 + blinkController.value * 0.5,
                  )
                : color.withValues(alpha: 0.35),
            size: 27,
          ),
        );
      },
    );
  }

  Widget demoButton(String label, String level, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          riskLevel = level;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Analysis Results',
          style: TextStyle(
            color: AppColors.darkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 15),

            const Text(
              'Your Security Report',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),

            const SizedBox(height: 22),

            // TRAFFIC LIGHT
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF29252E),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  trafficLight('High', Colors.red),
                  const SizedBox(height: 14),
                  trafficLight('Medium', Colors.amber),
                  const SizedBox(height: 14),
                  trafficLight('Low', Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Text(
              riskLevel == 'Uncertain'
                  ? 'Awaiting Analysis'
                  : '$riskLevel Risk',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: activeColor,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Preview Mode: This is not an actual AI assessment.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),

            const SizedBox(height: 25),

            // DEMO CONTROLS
            const Text(
              'Traffic Light Preview Controls',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                demoButton('Red', 'High', Colors.red),
                demoButton('Yellow', 'Medium', Colors.amber),
                demoButton('Green', 'Low', Colors.green),
              ],
            ),

            const SizedBox(height: 25),

            // RISK SCORE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Score',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.darkPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Not available yet. AI analysis is not connected.',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ANALYSIS DETAILS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security Insights',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.darkPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No security insights are available yet. '
                    'Connect the AI analysis service to receive '
                    'suspicious signals and safety recommendations.',
                    style: TextStyle(color: AppColors.textGrey, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // BACK TO HOME
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
