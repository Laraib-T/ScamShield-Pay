import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/compare_result.dart';
import 'analysis_service.dart';

class CompareService {
  static Future<CompareResult> compare({
    required String brand,
    required String product,
    required List<Map<String, dynamic>> listings,
  }) async {
    final response = await http
        .post(
          Uri.parse('${AnalysisService.baseUrl}/compare'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'brand': brand,
            'product': product,
            'listings': listings,
          }),
        )
        .timeout(const Duration(seconds: 40));

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final message = (data is Map && data['error'] != null)
          ? data['error'].toString()
          : 'Server error (${response.statusCode})';
      throw Exception(message);
    }

    return CompareResult.fromJson(Map<String, dynamic>.from(data as Map));
  }
}