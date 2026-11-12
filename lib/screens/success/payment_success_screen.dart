import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String amount;
  final String transactionId;

  const PaymentSuccessScreen({
    super.key,
    required this.amount,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 70,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Payment Successful',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('\$$amount USD', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 14),
                if (transactionId.isNotEmpty)
                  SelectableText(
                    'Transaction ID: $transactionId',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                const SizedBox(height: 8),
                const Text(
                  'Sandbox test payment. No real money was charged.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
