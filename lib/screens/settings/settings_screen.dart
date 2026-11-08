
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.darkPurple,
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'GENERAL',
            style: TextStyle(
              color: AppColors.textGrey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SwitchListTile(
              secondary: const Icon(
                Icons.notifications_outlined,
                color: AppColors.purple,
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkPurple,
                ),
              ),
              subtitle: const Text(
                'Notification preference (preview)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              activeThumbColor: AppColors.purple,
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),

          settingTile(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            subtitle: 'Learn about data handling',
            onTap: () => showInfo(
              context,
              'Privacy & Security',
              'ScamShield Pay is currently in preview mode. '
                  'Live AI analysis and scan history storage '
                  'are not connected yet. Never share your '
                  'passwords or payment PINs.',
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'SUPPORT',
            style: TextStyle(
              color: AppColors.textGrey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          settingTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Learn how to use the application',
            onTap: () => showInfo(
              context,
              'Help & Support',
              'To use ScamShield Pay, open Analyze, '
                  'enter a payment link or seller details, '
                  'and continue to the preview report. '
                  'Live scam detection is not available yet.',
            ),
          ),

          settingTile(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Learn more about our application',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'ScamShield Pay',
                applicationVersion: '1.0.0',
                applicationLegalese:
                    'Stay alert. Stay protected. Pay safely.',
              );
            },
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.shield_rounded,
                  size: 42,
                  color: AppColors.purple,
                ),

                SizedBox(height: 10),

                Text(
                  'ScamShield Pay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPurple,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Stay alert. Stay protected.',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Icon(
          icon,
          color: AppColors.purple,
          size: 25,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.darkPurple,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textGrey,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColors.textGrey,
        ),
      ),
    );
  }

  void showInfo(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.purple),
            ),
          ),
        ],
      ),
    );
  }
}
