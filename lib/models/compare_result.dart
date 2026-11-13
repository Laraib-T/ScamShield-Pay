class EvidenceNote {
  final String type; // good | warn | bad | unknown
  final String text;

  const EvidenceNote({required this.type, required this.text});

  factory EvidenceNote.fromJson(Map<String, dynamic> json) {
    return EvidenceNote(
      type: (json['type'] ?? 'unknown').toString(),
      text: (json['text'] ?? '').toString(),
    );
  }
}

class SellerResult {
  final String domain;
  final int trustScore;
  final String verdict; // safe | caution | risky
  final String authorization;
  final List<EvidenceNote> notes;

  const SellerResult({
    required this.domain,
    required this.trustScore,
    required this.verdict,
    required this.authorization,
    required this.notes,
  });

  factory SellerResult.fromJson(Map<String, dynamic> json) {
    return SellerResult(
      domain: (json['domain'] ?? '').toString(),
      trustScore: ((json['trust_score'] as num?)?.round() ?? 0).clamp(0, 100),
      verdict: (json['verdict'] ?? 'caution').toString(),
      authorization: (json['authorization'] ?? 'unknown').toString(),
      notes: ((json['notes'] as List?) ?? [])
          .map((e) => EvidenceNote.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class CompareResult {
  final int bestIndex;
  final List<SellerResult> results;

  const CompareResult({required this.bestIndex, required this.results});

  factory CompareResult.fromJson(Map<String, dynamic> json) {
    return CompareResult(
      bestIndex: (json['best_index'] as num?)?.toInt() ?? 0,
      results: ((json['results'] as List?) ?? [])
          .map((e) => SellerResult.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}