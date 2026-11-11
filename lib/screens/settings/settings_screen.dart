import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subtitleColor = isDark ? Colors.white70 : AppColors.textGrey;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Settings',
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          sectionTitle('APPEARANCE', subtitleColor),
          const SizedBox(height: 12),

          Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.palette_outlined,
                          color: AppColors.purple,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Choose Theme',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  themeOption(
                    title: 'Light Mode',
                    subtitle: 'Use the light appearance',
                    value: ThemeMode.light,
                    icon: Icons.light_mode_outlined,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  themeOption(
                    title: 'Dark Mode',
                    subtitle: 'Use the dark appearance',
                    value: ThemeMode.dark,
                    icon: Icons.dark_mode_outlined,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  themeOption(
                    title: 'System Default',
                    subtitle: 'Follow your device settings',
                    value: ThemeMode.system,
                    icon: Icons.settings_brightness_outlined,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          sectionTitle('GENERAL', subtitleColor),
          const SizedBox(height: 12),

          Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              secondary: const Icon(
                Icons.notifications_outlined,
                color: AppColors.purple,
              ),
              title: Text(
                'Notifications',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                notificationsEnabled
                    ? 'Notifications are enabled'
                    : 'Notifications are disabled',
                style: TextStyle(fontSize: 12, color: subtitleColor),
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
            subtitle: 'Your privacy and account safety',
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onTap: () => showInfo(
              'Privacy & Security',
              'ScamShield Pay is designed to help users '
                  'identify suspicious payment activity.\n\n'
                  '• Never share your passwords or payment PINs.\n'
                  '• Avoid opening suspicious payment links.\n'
                  '• Your account uses Firebase Authentication.\n'
                  '• Live AI analysis and scan history storage '
                  'are still being integrated.',
            ),
          ),

          const SizedBox(height: 25),

          sectionTitle('SUPPORT', subtitleColor),
          const SizedBox(height: 12),

          settingTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Learn how to use the application',
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onTap: () => showInfo(
              'Help & Support',
              'How to use ScamShield Pay:\n\n'
                  '1. Open the Analyze section.\n'
                  '2. Enter a payment link or seller details.\n'
                  '3. Continue to the analysis screen.\n'
                  '4. Review the available report.\n\n'
                  'Live AI scam detection is still being integrated.',
            ),
          ),

          settingTile(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Application information',
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'ScamShield Pay',
                applicationVersion: '1.0.0',
                applicationIcon: Image.asset(
                  'assets/images/logo.png',
                  width: 55,
                  height: 55,
                ),
                applicationLegalese: 'Stay alert. Stay protected. Pay safely.',
              );
            },
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF35233F), Color(0xFF24182F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : AppColors.backgroundGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 85,
                  height: 85,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),

                Text(
                  'ScamShield Pay',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.darkPurple,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Version 1.0.0',
                  style: TextStyle(color: subtitleColor, fontSize: 13),
                ),

                const SizedBox(height: 10),

                Text(
                  'Stay alert. Stay protected. Pay safely.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: subtitleColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1,
      ),
    );
  }

  Widget themeOption({
    required String title,
    required String subtitle,
    required ThemeMode value,
    required IconData icon,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return RadioListTile<ThemeMode>(
      value: value,
      groupValue: ThemeController.instance.themeMode,
      activeColor: AppColors.purple,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      secondary: Icon(icon, color: AppColors.purple, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: subtitleColor, fontSize: 11),
      ),
      onChanged: (value) {
        if (value != null) {
          ThemeController.instance.setThemeMode(value);
        }
      },
    );
  }

  Widget settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: cardColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Icon(icon, color: AppColors.purple, size: 25),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: subtitleColor),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: subtitleColor,
        ),
      ),
    );
  }

  void showInfo(String title, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.darkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.textGrey,
              height: 1.6,
              fontSize: 14,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppColors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
