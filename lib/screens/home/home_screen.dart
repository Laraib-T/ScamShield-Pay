import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget sectionTitle(String title, {String? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.darkPurple,
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: () => showMessage('History will be available soon.'),
            child: Text(
              action,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget featureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.07),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: iconColor, size: 25),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.darkPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget recentScan({
    required String name,
    required String description,
    required int score,
    required bool safe,
    required IconData productIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: AppColors.lavender.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              productIcon,
              color: AppColors.primary,
              size: 27,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  safe ? 'Low Risk' : 'High Risk',
                  style: TextStyle(
                    color: safe ? AppColors.success : AppColors.danger,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: safe ? AppColors.success : AppColors.danger,
                ),
              ),
              const Text(
                'Trust Score',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(width: 7),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textGrey,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 15, 22, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    height: 43,
                    width: 43,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primary,
                          Color(0xFF9870A8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      AppConstants.appName,
                      style: TextStyle(
                        color: AppColors.darkPurple,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 43,
                    width: 43,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () =>
                          showMessage('No new notifications.'),
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Welcome heading
              const Text(
                'Stay Safe Before\\nYou Pay!',
                style: TextStyle(
                  color: AppColors.darkPurple,
                  fontSize: 30,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Shop online with confidence. Let AI check\\n'
                'the seller before you make a payment.',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 22),

              // Main illustration-style banner
              Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFEBD9F2),
                      Color(0xFFF8E3F1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      top: 12,
                      child: Icon(
                        Icons.auto_awesome,
                        color: AppColors.primary.withOpacity(0.4),
                        size: 25,
                      ),
                    ),
                    Positioned(
                      right: 35,
                      bottom: 10,
                      child: Icon(
                        Icons.circle,
                        color: Colors.white.withOpacity(0.5),
                        size: 35,
                      ),
                    ),
                    Positioned(
                      right: 45,
                      top: 25,
                      child: Container(
                        height: 125,
                        width: 125,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.primary,
                          size: 75,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 20,
                      top: 37,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shop Smart,',
                            style: TextStyle(
                              color: AppColors.darkPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Stay Protected!',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Your AI safety\\ncompanion.',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Analyze button
              Container(
                width: double.infinity,
                height: 57,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      Color(0xFF9870A8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 13,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => showMessage(
                    'Analyze screen will be connected next.',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Analyze Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              sectionTitle('Start Checking'),

              const SizedBox(height: 13),

              Row(
                children: [
                  featureCard(
                    title: 'Paste a Link',
                    subtitle: 'Check a seller or\\npayment link',
                    icon: Icons.link_rounded,
                    iconColor: AppColors.primary,
                    onTap: () => showMessage(
                      'Link analysis will be connected next.',
                    ),
                  ),
                  const SizedBox(width: 13),
                  featureCard(
                    title: 'Upload Screenshot',
                    subtitle: 'Check seller chats\\nand product details',
                    icon: Icons.image_outlined,
                    iconColor: AppColors.danger,
                    onTap: () => showMessage(
                      'Screenshot analysis will be connected next.',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              sectionTitle(
                AppConstants.recentScans,
                action: 'See All',
              ),

              const SizedBox(height: 8),

              recentScan(
                name: 'Wireless Headphones',
                description: 'Example scan · 2 hours ago',
                score: 92,
                safe: true,
                productIcon: Icons.headphones_rounded,
              ),

              recentScan(
                name: 'Designer Handbag',
                description: 'Example scan · Yesterday',
                score: 32,
                safe: false,
                productIcon: Icons.shopping_bag_outlined,
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.07),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(Icons.home_rounded, 'Home', 0),
                navItem(Icons.history_rounded, 'History', 1),
                navItem(Icons.settings_outlined, 'Settings', 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, String label, int index) {
    final selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
        if (index != 0) {
          showMessage('$label screen will be connected later.');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.lavender.withOpacity(0.55)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected
                  ? AppColors.primary
                  : AppColors.textGrey,
              size: 23,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: selected
                    ? AppColors.primary
                    : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}