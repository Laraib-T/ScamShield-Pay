
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/payment_service.dart';
import '../success/payment_success_screen.dart';

enum _Stage { amount, ready, waiting }

class PaypalCheckoutScreen extends StatefulWidget {
  const PaypalCheckoutScreen({super.key});

  @override
  State<PaypalCheckoutScreen> createState() => _PaypalCheckoutScreenState();
}

class _PaypalCheckoutScreenState extends State<PaypalCheckoutScreen> {
  final TextEditingController amountCtrl = TextEditingController(text: '18.00');

  _Stage stage = _Stage.amount;
  PaymentSession? session;
  Timer? poll;
  bool busy = false;
  String? error;

  @override
  void dispose() {
    poll?.cancel();
    amountCtrl.dispose();
    super.dispose();
  }

  Future<void> createSession() async {
    final amount = double.tryParse(amountCtrl.text.trim());

    if (amount == null || amount < 1 || amount > 1000) {
      setState(() => error = 'Enter an amount between 1 and 1000 USD.');
      return;
    }

    setState(() {
      busy = true;
      error = null;
    });

    try {
      final s = await PaymentService.createSession(
        amount: amount,
        description: 'Purchase checked by ScamShield Pay',
      );
      if (!mounted) return;
      setState(() {
        session = s;
        stage = _Stage.ready;
      });
    } catch (e) {
      if (!mounted) return;
      final text = e.toString();
      setState(() {
        error = (text.contains('Failed to fetch') || text.contains('ClientException'))
            ? 'Cannot reach the ScamShield server. Make sure the backend is running.'
            : text.replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  // Ye seedha button tap se chalta hai, taake browser naya tab block na kare
  Future<void> openCheckout() async {
    final s = session;
    if (s == null) return;

    final opened = await launchUrl(
      Uri.parse(s.payUrl),
      webOnlyWindowName: '_blank',
    );

    if (!mounted) return;

    if (!opened) {
      setState(() => error = 'Could not open the checkout page. Allow pop-ups and try again.');
      return;
    }

    setState(() {
      stage = _Stage.waiting;
      error = null;
    });
    startPolling();
  }

  void startPolling() {
    poll?.cancel();
    int ticks = 0;

    poll = Timer.periodic(const Duration(seconds: 2), (timer) async {
      ticks++;

      // 15 minute ke baad session expire ho jata hai
      if (ticks > 450) {
        timer.cancel();
        if (mounted) {
          setState(() {
            stage = _Stage.amount;
            session = null;
            error = 'The checkout session expired. Please start again.';
          });
        }
        return;
      }

      try {
        final st = await PaymentService.getStatus(session!.sessionId);
        if (!mounted) return;

        if (st.status == 'paid') {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(
                amount: st.amount ?? amountCtrl.text.trim(),
                transactionId: st.transactionId ?? '',
              ),
            ),
          );
        } else if (st.status == 'expired') {
          timer.cancel();
          setState(() {
            stage = _Stage.amount;
            session = null;
            error = 'The checkout session expired. Please start again.';
          });
        }
      } catch (_) {
        // Temporary network error: agli baar dobara poochhenge
      }
    });
  }

  void startOver() {
    poll?.cancel();
    setState(() {
      stage = _Stage.amount;
      session = null;
      error = null;
    });
  }

  Widget sandboxNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'Test mode (Braintree sandbox). No real money is charged.\n'
        'Test card: 4111 1111 1111 1111, any future expiry date, CVV 123.',
        style: TextStyle(fontSize: 13, height: 1.5),
      ),
    );
  }

  Widget amountStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How much are you paying?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text('Enter the amount from the listing, in US dollars.'),
        const SizedBox(height: 14),
        TextField(
          controller: amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            prefixText: '\$ ',
            labelText: 'Amount (USD)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: busy ? null : createSession,
            child: busy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Text('Continue'),
          ),
        ),
      ],
    );
  }

  Widget readyStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your secure checkout is ready',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text('Amount: \$${amountCtrl.text.trim()} USD'),
        const SizedBox(height: 6),
        const Text(
          'The card form opens in a new tab. When you finish paying, come back to this tab.',
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: openCheckout,
            icon: const Icon(Icons.lock_rounded),
            label: const Text('Open secure checkout'),
          ),
        ),
        TextButton(onPressed: startOver, child: const Text('Change amount')),
      ],
    );
  }

  Widget waitingStage() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        const Text(
          'Waiting for your payment...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Finish paying in the checkout tab. This screen updates by itself.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        OutlinedButton(
          onPressed: openCheckout,
          child: const Text('Open checkout tab again'),
        ),
        TextButton(onPressed: startOver, child: const Text('Cancel')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (stage) {
      case _Stage.amount:
        body = amountStage();
        break;
      case _Stage.ready:
        body = readyStage();
        break;
      case _Stage.waiting:
        body = waitingStage();
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Secure Payment'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          sandboxNotice(),
          const SizedBox(height: 22),
          body,
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}