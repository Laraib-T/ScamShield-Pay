import 'dart:convert';
import 'package:http/http.dart' as http;

import 'analysis_service.dart';

class PaymentSession {
  final String sessionId;
  final String payUrl;

  const PaymentSession({required this.sessionId, required this.payUrl});
}

class PaymentStatus {
  final String status; // pending | processing | paid | expired
  final String? transactionId;
  final String? amount;
  final String? lastError;

  const PaymentStatus({
    required this.status,
    this.transactionId,
    this.amount,
    this.lastError,
  });
}

class PaymentService {
  static String get _base => AnalysisService.baseUrl;

  static Future<PaymentSession> createSession({
    required double amount,
    String description = 'ScamShield Pay purchase',
  }) async {
    final response = await http
        .post(
          Uri.parse('$_base/braintree/session'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'amount': amount, 'description': description}),
        )
        .timeout(const Duration(seconds: 20));

    final data = jsonDecode(response.body);

    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(
        (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Could not start the payment.',
      );
    }

    return PaymentSession(
      sessionId: data['sessionId'].toString(),
      payUrl: data['payUrl'].toString(),
    );
  }

  static Future<PaymentStatus> getStatus(String sessionId) async {
    final response = await http
        .get(Uri.parse('$_base/braintree/session/$sessionId'))
        .timeout(const Duration(seconds: 15));

    final data = jsonDecode(response.body);

    return PaymentStatus(
      status: (data['status'] ?? 'pending').toString(),
      transactionId: data['transactionId']?.toString(),
      amount: data['amount']?.toString(),
      lastError: data['lastError']?.toString(),
    );
  }
}
