
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_button.dart';
import '../analyze/analyze_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // MAIN BODY
      body: LayoutBuilder(
        builder: (context, constraints) {
          final appWidth = constraints.maxWidth > 480
              ? 480.0
              : constraints.maxWidth;

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.background,
            child: Center(
              child: SizedBox(
                width: appWidth,
                height: constraints.maxHeight,

                child: Stack(
                  fit: StackFit.expand,
                  children: [

                    // GRADIENT BACKGROUND
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.backgroundGradient,
                      ),
                    ),

                    // CURVED BACKGROUND
                    CustomPaint(
                      painter: HomeBackgroundPainter(),
                    ),

                    // FADED SHIELD WATERMARK
                    Positioned(
                      top: 145,
                      right: -35,
                      child: Icon(
                        Icons.shield_rounded,
                        size: 230,
                        color: AppColors.purple.withOpacity(0.07),
                      ),
                    ),

                    // HOME CONTENT
                    SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          22, 12, 22, 25,
                        ),

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

                                const Expanded(
                                  child: Text(
                                    'ScamShield Pay',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.darkPurple,
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
                                  icon: const Icon(
                                    Icons.notifications_none_rounded,
                                    color: AppColors.darkPurple,
                                    size: 27,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 35),

                            // MAIN HEADING
                            const Text(
                              'Let AI Check\nBefore You Pay!',
                              style: TextStyle(
                                fontSize: 30,
                                height: 1.2,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkPurple,
                                letterSpacing: -0.7,
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'Shop smart. Stay protected.\n'
                              'Pay with confidence.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: AppColors.textGrey,
                              ),
                            ),

                            const SizedBox(height: 25),

                            // HERO ILLUSTRATION
                            Container(
                              height: 155,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
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
                                      color: AppColors.purple
                                          .withOpacity(0.5),
                                      size: 25,
                                    ),
                                  ),

                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_rounded,
                                        size: 85,
                                        color: Color(0xFFA66BB9),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.verified_user_rounded,
                                        size: 90,
                                        color: AppColors.darkPurple,
                                      ),
                                    ],
                                  ),

                                  Positioned(
                                    bottom: 15,
                                    left: 18,
                                    child: Icon(
                                      Icons.spa_rounded,
                                      color: AppColors.purple
                                          .withOpacity(0.4),
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

                            // TWO OPTION CARDS
                            Row(
                              children: [
                                Expanded(
                                  child: optionCard(
                                    icon: Icons.link_rounded,
                                    title: 'Paste Listing /\nPayment Link',
                                    onTap: () {
                                      showMessage(
                                        context,
                                        'Paste your payment link',
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(width: 13),

                                Expanded(
                                  child: optionCard(
                                    icon: Icons.image_rounded,
                                    title: 'Upload\nScreenshot',
                                    onTap: () {
                                      showMessage(
                                        context,
                                        'Select a screenshot',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // RECENT SCANS HEADER
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recent Scans',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkPurple,
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    showMessage(
                                      context,
                                      'Scan history coming soon',
                                    );
                                  },
                                  child: const Text(
                                    'View All  ›',
                                    style: TextStyle(
                                      color: AppColors.purple,
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
                                color: Colors.white.withOpacity(0.95),
                                borderRadius:
                                    BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.purple
                                        .withOpacity(0.08),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),

                              child: const Row(
                                children: [
                                  CircleAvatar(
                                    radius: 27,
                                    backgroundColor:
                                        AppColors.lavender,
                                    child: Icon(
                                      Icons.shopping_bag_rounded,
                                      color: AppColors.purple,
                                      size: 28,
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'No scans yet',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                AppColors.darkPurple,
                                          ),
                                        ),

                                        SizedBox(height: 5),

                                        Text(
                                          'Your recent scans will appear here.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                AppColors.textGrey,
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

      // FIXED BOTTOM NAVIGATION
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final navWidth = constraints.maxWidth > 480
                  ? 480.0
                  : constraints.maxWidth;

              return Center(
                child: SizedBox(
                  width: navWidth,
                  child: BottomNavigationBar(
                    backgroundColor: Colors.white,
                    elevation: 8,
                    selectedItemColor: AppColors.purple,
                    unselectedItemColor: AppColors.textGrey,
                    currentIndex: 0,
                    type: BottomNavigationBarType.fixed,

                    onTap: (index) {
                      if (index == 1) {
                        showMessage(
                          context,
                          'History screen coming soon',
                        );
                      } else if (index == 2) {
                        showMessage(
                          context,
                          'Settings screen coming soon',
                        );
                      }
                    },

                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_rounded),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.history_rounded),
                        label: 'History',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings_rounded),
                        label: 'Settings',
                      ),
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

  // REUSABLE OPTION CARD
  Widget optionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 125,
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withOpacity(0.09),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.purple,
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textDark,
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
  @override
  void paint(Canvas canvas, Size size) {
    final pinkPaint = Paint()
      ..color = const Color(0x30E8B6E9)
      ..style = PaintingStyle.fill;

    final purplePaint = Paint()
      ..color = const Color(0x35C9A3E5)
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.65, 0)
      ..quadraticBezierTo(
        size.width * 0.48,
        70,
        size.width * 0.18,
        95,
      )
      ..quadraticBezierTo(
        size.width * 0.05,
        105,
        0,
        155,
      )
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
    return false;
  }
}
