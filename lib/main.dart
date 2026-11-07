import 'package:flutter/material.dart';

void main() {
  runApp(const ScamShieldPay());
}

class AppColors {
  static const purple = Color(0xFF713A82);
  static const darkPurple = Color(0xFF452052);
  static const lavender = Color(0xFFEAD8F3);
  static const background = Color(0xFFFFF5FC);
  static const pink = Color(0xFFF8DDF0);
  static const green = Color(0xFF36A66A);
  static const red = Color(0xFFE54D72);
  static const orange = Color(0xFFFFB45C);
}

class ScamShieldPay extends StatelessWidget {
  const ScamShieldPay({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScamShield Pay',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.purple,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8E8FA),
              Color(0xFFFFF8FC),
              Color(0xFFF1DFF7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 145,
                width: 145,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF9A5AB0),
                      Color(0xFF542265),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 95,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'ScamShield Pay',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPurple,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Think Before You Pay.',
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.purple,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 55),

              const Icon(
                Icons.shopping_bag_outlined,
                size: 95,
                color: AppColors.purple,
              ),

              const SizedBox(height: 55),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}