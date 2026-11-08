
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../auth/welcome_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        // BACK BUTTON
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.darkPurple,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 25),

            // PROFILE IMAGE
            Container(
              height: 115,
              width: 115,
              decoration: const BoxDecoration(
                color: AppColors.lavender,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 70,
                color: AppColors.purple,
              ),
            ),

            const SizedBox(height: 18),

            // USER NAME
            Text(
              user?.displayName?.isNotEmpty == true
                  ? user!.displayName!
                  : 'User',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),

            const SizedBox(height: 8),

            // USER EMAIL
            Text(
              user?.email ?? 'No email available',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
            ),

            const SizedBox(height: 30),

            // ACCOUNT INFORMATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurple,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.email_outlined,
                      color: AppColors.purple,
                    ),
                    title: const Text('Email Verification'),
                    subtitle: Text(
                      user?.emailVerified == true
                          ? 'Verified'
                          : 'Not verified',
                    ),
                    trailing: Icon(
                      user?.emailVerified == true
                          ? Icons.verified
                          : Icons.info_outline,
                      color: user?.emailVerified == true
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),

                  const Divider(),

                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.security_rounded,
                      color: AppColors.purple,
                    ),
                    title: Text('Account Status'),
                    subtitle: Text('Firebase Authentication'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // SETTINGS
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SettingsScreen(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.purple,
                  size: 28,
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Privacy, support and app information',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // LOGOUT
            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton.icon(
                onPressed: () => logout(context),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
