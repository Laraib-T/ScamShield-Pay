
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/scan_result.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please login to save scan history.');
    }

    return user.uid;
  }

  Future<void> saveScan({
    required String input,
    required ScanResult result,
  }) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('scan_history')
        .add({
      'input': input,
      'riskLevel': result.riskLevel,
      'trustScore': result.trustScore,
      'verdict': result.verdict,
      'summary': result.summary,
      'scannedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getScanHistory() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('scan_history')
        .orderBy('scannedAt', descending: true)
        .snapshots();
  }
}
