
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/app_bottom_nav.dart';
import '../analyze/analyze_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  void openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF261C30) : Colors.white;
    final headingColor = isDark ? Colors.white : AppColors.darkPurple;
    final subtitleColor = isDark ? Colors.white70 : AppColors.textGrey;

    return Scaffold(
      backgroundColor: backgroundColor,

      body: LayoutBuilder(
        builder: (context, constraints) {
          final appWidth = constraints.maxWidth > 480
              ? 480.0
              : constraints.maxWidth;

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: backgroundColor,
            child: Center(
              child: SizedBox(
                width: appWidth,
                height: constraints.maxHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? const LinearGradient(
                                colors: [Color(0xFF17111D), Color(0xFF24182F)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : AppColors.backgroundGradient,
                      ),
                    ),

                    CustomPaint(painter: HomeBackgroundPainter(isDark: isDark)),

                    Positioned(
                      top: 145,
                      right: -35,
                      child: Icon(
                        Icons.shield_rounded,
                        size: 230,
                        color: AppColors.softPurple.withValues(
                          alpha: isDark ? 0.08 : 0.07,
                        ),
                      ),
                    ),

                    SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(22, 12, 22, 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TOP BAR
                            Row(
                              children: [
                                Container(
                                  height: 46,
                                  width: 46,
                                  decoration: const BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.shield_rounded,
                                        color: Colors.white,
                                        size: 38,
                                      ),
                                      Icon(
                                        Icons.shopping_cart_rounded,
                                        color: AppColors.darkPurple,
                                        size: 17,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    'ScamShield Pay',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: headingColor,
                                    ),
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    showMessage(
                                      context,
                                      'No new notifications',
                                    );
                                  },
                                  icon: Icon(
                                    Icons.notifications_none_rounded,
                                    color: headingColor,
                                    size: 27,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 35),

                            // MAIN HEADING
                            Text(
                              'Let AI Check\nBefore You Pay!',
                              style: TextStyle(
                                fontSize: 30,
                                height: 1.2,
                                fontWeight: FontWeight.w800,
                                color: headingColor,
                                letterSpacing: -0.7,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'Shop smart. Stay protected.\n'
                              'Pay with confidence.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: subtitleColor,
                              ),
                            ),

                            const SizedBox(height: 25),

                            // HERO ILLUSTRATION
                            Container(
                              height: 155,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: isDark
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF35233F),
                                          Color(0xFF493052),
                                          Color(0xFF33243B),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : const LinearGradient(
                                        colors: [
                                          Color(0xFFF9E5F5),
                                          Color(0xFFEAD7F5),
                                          Color(0xFFFFEBD9),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    top: 12,
                                    right: 20,
                                    child: Icon(
                                      Icons.auto_awesome,
                                      color: AppColors.softPurple.withValues(
                                        alpha: 0.7,
                                      ),
                                      size: 25,
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_rounded,
                                        size: 85,
                                        color: isDark
                                            ? const Color(0xFFC69AD8)
                                            : const Color(0xFFA66BB9),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.verified_user_rounded,
                                        size: 90,
                                        color: isDark
                                            ? const Color(0xFFE1B8F0)
                                            : AppColors.darkPurple,
                                      ),
                                    ],
                                  ),

                                  Positioned(
                                    bottom: 15,
                                    left: 18,
                                    child: Icon(
                                      Icons.spa_rounded,
                                      color: AppColors.softPurple.withValues(
                                        alpha: 0.6,
                                      ),
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),

                            // MAIN BUTTON
                            GradientButton(
                              text: 'Check Before You Pay',
                              icon: Icons.arrow_forward_rounded,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AnalyzeScreen(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 22),

                            // OPTION CARDS
                            Row(
                              children: [
                                Expanded(
                                  child: optionCard(
                                    icon: Icons.link_rounded,
                                    title: 'Paste Product\nLink',
                                    isDark: isDark,
                                    cardColor: cardColor,
                                    textColor: headingColor,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AnalyzeScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(width: 13),

                                Expanded(
                                  child: optionCard(
                                    icon: Icons.image_rounded,
                                    title: 'Upload\nScreenshot',
                                    isDark: isDark,
                                    cardColor: cardColor,
                                    textColor: headingColor,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AnalyzeScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // RECENT SCANS HEADER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Scans',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: headingColor,
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    openHistory(context);
                                  },
                                  child: const Text(
                                    'View All  ›',
                                    style: TextStyle(
                                      color: AppColors.softPurple,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // EMPTY HISTORY CARD
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(17),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.purple.withValues(
                                      alpha: isDark ? 0.03 : 0.08,
                                    ),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 27,
                                    backgroundColor: isDark
                                        ? const Color(0xFF493052)
                                        : AppColors.lavender,
                                    child: const Icon(
                                      Icons.shopping_bag_rounded,
                                      color: AppColors.softPurple,
                                      size: 28,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'No scans yet',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: headingColor,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          'Your recent scans will appear here.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: subtitleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final navWidth = constraints.maxWidth > 480
                  ? 480.0
                  : constraints.maxWidth;

              return Center(
                child: SizedBox(
                  width: navWidth,
                  child: AppBottomNav(
                    currentIndex: 0,
                    onTap: (index) {
                      if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnalyzeScreen(),
                          ),
                        );
                      } else if (index == 2) {
                        openHistory(context);
                      } else if (index == 3) {
                        openProfile(context);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // REUSABLE OPTION CARD
  Widget optionCard({
    required IconData icon,
    required String title,
    required bool isDark,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 125,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withValues(alpha: isDark ? 0.03 : 0.09),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.softPurple),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CURVED BACKGROUND PAINTER
class HomeBackgroundPainter extends CustomPainter {
  final bool isDark;

  HomeBackgroundPainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final pinkPaint = Paint()
      ..color = isDark ? const Color(0x183F2850) : const Color(0x30E8B6E9)
      ..style = PaintingStyle.fill;

    final purplePaint = Paint()
      ..color = isDark ? const Color(0x203B2850) : const Color(0x35C9A3E5)
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.65, 0)
      ..quadraticBezierTo(size.width * 0.48, 70, size.width * 0.18, 95)
      ..quadraticBezierTo(size.width * 0.05, 105, 0, 155)
      ..close();

    final path2 = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width * 0.35, size.height)
      ..quadraticBezierTo(
        size.width * 0.65,
        size.height - 55,
        size.width,
        size.height - 135,
      )
      ..close();

    canvas.drawPath(path1, pinkPaint);
    canvas.drawPath(path2, purplePaint);
  }

  @override
  bool shouldRepaint(covariant HomeBackgroundPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
