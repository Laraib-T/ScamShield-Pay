import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/scan_result.dart';

class AnalysisService {
  // Chrome ya Windows par chalane ke liye localhost theek hai.
  // Android emulator ke liye:  http://10.0.2.2:3000
  // Asli phone ke liye:        http://<laptop-ka-IP>:3000
  static const String baseUrl = 'http://localhost:3000';

  static Future<ScanResult> analyze({
    String? text,
    String? imageBase64,
    String? mediaType,
  }) async {
    final body = <String, dynamic>{};

    if (text != null && text.trim().isNotEmpty) {
      body['text'] = text.trim();
    }
    if (imageBase64 != null && imageBase64.isNotEmpty) {
      body['imageBase64'] = imageBase64;
      body['mediaType'] = mediaType ?? 'image/jpeg';
    }
    if (body.isEmpty) {
      throw Exception('Please enter a listing or choose a screenshot.');
    }

    final response = await http
        .post(
          Uri.parse('$baseUrl/analyze'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final message = (data is Map && data['error'] != null)
          ? data['error'].toString()
          : 'Server error (${response.statusCode})';
      throw Exception(message);
    }

    return ScanResult.fromJson(Map<String, dynamic>.from(data as Map));
  }
}