
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/app_colors.dart';
import '../../services/history_service.dart';
import '../analyze/analyze_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppColors.darkPurple),
        title: const Text(
          'Scan History',
          style: TextStyle(
            color: AppColors.darkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: user == null
          ? _buildMessage(
              icon: Icons.lock_outline,
              title: 'Login Required',
              message: 'Please login to view your scan history.',
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: HistoryService().getScanHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.purple,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _buildMessage(
                    icon: Icons.error_outline,
                    title: 'Something Went Wrong',
                    message: 'Unable to load your scan history.',
                  );
                }

                final scans = snapshot.data?.docs ?? [];

                if (scans.isEmpty) {
                  return _buildEmptyState(context);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: Text(
                        '${scans.length} Total Scans',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        itemCount: scans.length,
                        itemBuilder: (context, index) {
                          final data = scans[index].data();

                          final input =
                              (data['input'] ?? 'Unknown Scan').toString();

                          final riskLevel =
                              (data['riskLevel'] ?? 'Medium').toString();

                          final trustScore =
                              (data['trustScore'] as num?)?.toInt() ?? 0;

                          final summary =
                              (data['summary'] ?? '').toString();

                          final scannedAt = data['scannedAt'];

                          String dateText = 'Date unavailable';

                          if (scannedAt is Timestamp) {
                            final date = scannedAt.toDate().toLocal();

                            final hour = date.hour % 12 == 0
                                ? 12
                                : date.hour % 12;

                            final minute =
                                date.minute.toString().padLeft(2, '0');

                            final period = date.hour >= 12 ? 'PM' : 'AM';

                            dateText =
                                '${date.day}/${date.month}/${date.year}  •  $hour:$minute $period';
                          }

                          final Color riskColor =
                              riskLevel.toLowerCase() == 'low'
                                  ? AppColors.green
                                  : riskLevel.toLowerCase() == 'high'
                                      ? AppColors.danger
                                      : AppColors.yellow;

                          return Card(
                            color: Theme.of(context).cardColor,
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightPink,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.history,
                                          color: AppColors.purple,
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Text(
                                          input,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: riskColor.withValues(
                                            alpha: 0.15,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          riskLevel,
                                          style: TextStyle(
                                            color: riskColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 14),

                                  Text(
                                    'Trust Score: $trustScore/100',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  if (summary.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      summary,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 15,
                                        color: AppColors.textGrey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        dateText,
                                        style: const TextStyle(
                                          color: AppColors.textGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.lavender,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history,
                size: 48,
                color: AppColors.purple,
              ),
            ),

            const SizedBox(height: 24),

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
              'Your previous payment and seller safety analyses will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalyzeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Start New Scan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.purple),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
