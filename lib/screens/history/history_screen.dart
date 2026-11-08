
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../analyze/analyze_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: AppColors.darkPurple,
        ),
        title: const Text(
          'Scan History',
          style: TextStyle(
            color: AppColors.darkPurple,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // HISTORY SUMMARY
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.purple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.history_rounded,
                    color: Colors.white,
                    size: 32,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Your Scan Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    '0 Total Scans',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Your previous scans will be saved here.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),

            const SizedBox(height: 20),

            // EMPTY STATE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 35,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.lavender,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.manage_search_rounded,
                      size: 55,
                      color: AppColors.purple,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'No Scan History Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurple,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Your previous payment, seller and '
                    'link safety analyses will appear here '
                    'once scan history is connected.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textGrey,
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AnalyzeScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Start New Scan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Scan history storage will be available soon.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
