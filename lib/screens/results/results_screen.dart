import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/scan_result.dart';

class ResultsScreen extends StatefulWidget {
  final ScanResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController blinkController;

  ScanResult get result => widget.result;
  String get riskLevel => result.riskLevel;

  @override
  void initState() {
    super.initState();

    blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    blinkController.dispose();
    super.dispose();
  }

  Color get activeColor {
    if (riskLevel == 'High') return Colors.red;
    if (riskLevel == 'Medium') return Colors.amber.shade700;
    if (riskLevel == 'Low') return Colors.green;
    return Colors.blueGrey;
  }

  Color severityColor(String severity) {
    switch (severity) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  Widget trafficLight(String level, Color color) {
    final bool isActive = riskLevel == level;

    return AnimatedBuilder(
      animation: blinkController,
      builder: (context, child) {
        final double opacity =
            isActive ? 0.45 + (blinkController.value * 0.55) : 0.15;

        return Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: opacity),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(
                        alpha: 0.3 + blinkController.value * 0.5,
                      ),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            Icons.circle,
            color: isActive
                ? Colors.white.withValues(
                    alpha: 0.5 + blinkController.value * 0.5,
                  )
                : color.withValues(alpha: 0.35),
            size: 27,
          ),
        );
      },
    );
  }

  Widget sectionCard({
    required String title,
    required Widget child,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.darkPurple,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget flagTile(FlagItem flag, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flag.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkPurple,
                  ),
                ),
                if (flag.detail.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    flag.detail,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget trustScoreCard() {
    return sectionCard(
      title: 'Trust Score',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${result.trustScore}',
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: activeColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 9, left: 4),
                child: Text(
                  '/ 100',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: result.trustScore / 100,
              minHeight: 10,
              color: activeColor,
              backgroundColor: activeColor.withValues(alpha: 0.15),
            ),
          ),
          if (result.summary.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              result.summary,
              style: const TextStyle(
                color: AppColors.textGrey,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void startPayment() {
    // Agla step: yahan Braintree/PayPal checkout screen khulegi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Secure checkout will be connected in the next step.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget paymentButton() {
    final bool canPay = result.canPay;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: canPay ? startPayment : null,
            icon: Icon(
              canPay ? Icons.lock_open_rounded : Icons.lock_rounded,
            ),
            label: Text(
              canPay ? 'Continue to Secure Payment' : 'Payment Locked',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        if (!canPay)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'We recommend not paying this seller, so payment is disabled for your safety.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ),
        if (canPay && riskLevel == 'Medium')
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Some warning signs were found. Verify the seller before paying.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Analysis Results',
          style: TextStyle(
            color: AppColors.darkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              'Your Security Report',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),
            const SizedBox(height: 22),

            // TRAFFIC LIGHT
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF29252E),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  trafficLight('High', Colors.red),
                  const SizedBox(height: 14),
                  trafficLight('Medium', Colors.amber),
                  const SizedBox(height: 14),
                  trafficLight('Low', Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Text(
              '$riskLevel Risk',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: activeColor,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'AI estimate, not a guarantee.',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),

            const SizedBox(height: 24),

            trustScoreCard(),

            if (result.redFlags.isNotEmpty)
              sectionCard(
                title: 'Warning Signs',
                child: Column(
                  children: result.redFlags
                      .map((f) => flagTile(
                            f,
                            severityColor(f.severity),
                            Icons.warning_amber_rounded,
                          ))
                      .toList(),
                ),
              ),

            if (result.greenFlags.isNotEmpty)
              sectionCard(
                title: 'Positive Signs',
                child: Column(
                  children: result.greenFlags
                      .map((f) => flagTile(
                            f,
                            Colors.green,
                            Icons.check_circle_outline_rounded,
                          ))
                      .toList(),
                ),
              ),

            if (result.questionsForSeller.isNotEmpty)
              sectionCard(
                title: 'Ask the Seller',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: result.questionsForSeller
                      .map(
                        (q) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.help_outline_rounded,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  q,
                                  style: const TextStyle(
                                    color: AppColors.textGrey,
                                    height: 1.4,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

            if (result.safeAdvice.isNotEmpty)
              sectionCard(
                title: 'Our Advice',
                borderColor: activeColor.withValues(alpha: 0.5),
                child: Text(
                  result.safeAdvice,
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    height: 1.5,
                  ),
                ),
              ),

            const SizedBox(height: 7),
            paymentButton(),
            const SizedBox(height: 14),

            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text(
                'Back to Home',
                style: TextStyle(
                  color: AppColors.darkPurple,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}