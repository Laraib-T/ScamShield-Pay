import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/analysis_service.dart';
import '../results/results_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final String text;
  final Uint8List? imageBytes;
  final String mediaType;

  const ProcessingScreen({
    super.key,
    this.text = '',
    this.imageBytes,
    this.mediaType = 'image/jpeg',
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  static const List<String> steps = [
    'Reading the listing...',
    'Checking the price against the market...',
    'Looking for pressure tactics...',
    'Reviewing the payment method...',
    'Preparing your security report...',
  ];

  String? errorMessage;
  int stepIndex = 0;
  Timer? stepTimer;

  @override
  void initState() {
    super.initState();
    startAnalysis();
  }

  @override
  void dispose() {
    stepTimer?.cancel();
    super.dispose();
  }

  String friendlyError(Object e) {
    final text = e.toString();

    if (text.contains('Failed to fetch') ||
        text.contains('ClientException') ||
        text.contains('SocketException')) {
      return 'Cannot reach the ScamShield server. '
          'Please make sure the backend is running and try again.';
    }
    if (text.contains('TimeoutException')) {
      return 'The analysis took too long. Please try again.';
    }
    return text.replaceFirst('Exception: ', '');
  }

  Future<void> startAnalysis() async {
    setState(() {
      errorMessage = null;
      stepIndex = 0;
    });

    stepTimer?.cancel();
    stepTimer = Timer.periodic(const Duration(milliseconds: 1800), (_) {
      if (!mounted) return;
      setState(() => stepIndex = (stepIndex + 1) % steps.length);
    });

    try {
      // Kam az kam 1.5 second loading dikhao taake screen jhalak na jaye
      final minWait = Future.delayed(const Duration(milliseconds: 1500));

      final result = await AnalysisService.analyze(
        text: widget.text,
        imageBase64: widget.imageBytes == null
            ? null
            : base64Encode(widget.imageBytes!),
        mediaType: widget.mediaType,
      );

      await minWait;

      if (!mounted) return;
      stepTimer?.cancel();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(result: result),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      stepTimer?.cancel();
      setState(() => errorMessage = friendlyError(e));
    }
  }

  Widget buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 110,
          width: 110,
          decoration: const BoxDecoration(
            color: AppColors.lavender,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shield_rounded,
            size: 65,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 30),
        const CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 4,
        ),
        const SizedBox(height: 30),
        const Text(
          'Analyzing...',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: AppColors.darkPurple,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            steps[stepIndex],
            key: ValueKey(stepIndex),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline_rounded,
            size: 58,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Analysis could not finish',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.darkPurple,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          errorMessage ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: startAnalysis,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Go Back',
            style: TextStyle(color: AppColors.darkPurple),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: errorMessage == null ? buildLoading() : buildError(),
          ),
        ),
      ),
    );
  }
}