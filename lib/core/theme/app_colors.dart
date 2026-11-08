
import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFFF6FB);
  static const Color lightPink = Color(0xFFFCE8F4);
  static const Color lavender = Color(0xFFEEDCF8);

  static const Color purple = Color(0xFF873E91);
  static const Color darkPurple = Color(0xFF54205F);
  static const Color softPurple = Color(0xFFC99BD8);

  // Compatibility with existing screens
  static const Color primary = purple;
  static const Color danger = Color(0xFFE34459);

  static const Color white = Colors.white;
  static const Color green = Color(0xFF35A85B);
  static const Color yellow = Color(0xFFF5C542);
  static const Color red = danger;

  static const Color textDark = Color(0xFF32163E);
  static const Color textGrey = Color(0xFF806C87);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF9B4BA1),
      Color(0xFF61226D),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFFFF7FB),
      Color(0xFFF1E3FA),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
