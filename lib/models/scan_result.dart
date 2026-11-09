class FlagItem {
  final String title;
  final String detail;
  final String detailUr;
  final String severity;

  const FlagItem({
    required this.title,
    this.detail = '',
    this.detailUr = '',
    this.severity = 'medium',
  });

  factory FlagItem.fromJson(Map<String, dynamic> json) {
    return FlagItem(
      title: (json['title'] ?? '').toString(),
      detail: (json['detail'] ?? '').toString(),
      detailUr: (json['detail_ur'] ?? '').toString(),
      severity: (json['severity'] ?? 'medium').toString(),
    );
  }
}

class ScanResult {
  // Team ke purane fields (riskScore: 0 = safe, 100 = bohat risky)
  final int riskScore;
  final String riskLevel; // 'Low' | 'Medium' | 'High'
  final List<String> reasons;

  // Backend se aane wale naye fields
  final int trustScore; // 0 = scam, 100 = bharosemand
  final String verdict; // safe | caution | risky
  final bool canPay;
  final String summary;
  final String summaryUr;
  final List<FlagItem> redFlags;
  final List<FlagItem> greenFlags;
  final List<String> questionsForSeller;
  final String safeAdvice;
  final String safeAdviceUr;

  const ScanResult({
    required this.riskScore,
    required this.riskLevel,
    required this.reasons,
    this.trustScore = 0,
    this.verdict = 'caution',
    this.canPay = false,
    this.summary = '',
    this.summaryUr = '',
    this.redFlags = const [],
    this.greenFlags = const [],
    this.questionsForSeller = const [],
    this.safeAdvice = '',
    this.safeAdviceUr = '',
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    final trust = ((json['trust_score'] as num?)?.round() ?? 50).clamp(0, 100);
    final verdict = (json['verdict'] ?? 'caution').toString();

    final red = ((json['red_flags'] as List?) ?? [])
        .map((e) => FlagItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final green = ((json['green_flags'] as List?) ?? [])
        .map((e) => FlagItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return ScanResult(
      riskScore: 100 - trust,
      riskLevel: verdict == 'safe'
          ? 'Low'
          : verdict == 'risky'
              ? 'High'
              : 'Medium',
      reasons: red
          .map((f) => f.detail.isNotEmpty ? '${f.title}: ${f.detail}' : f.title)
          .toList(),
      trustScore: trust,
      verdict: verdict,
      canPay: json['can_pay'] == true,
      summary: (json['summary'] ?? '').toString(),
      summaryUr: (json['summary_ur'] ?? '').toString(),
      redFlags: red,
      greenFlags: green,
      questionsForSeller: ((json['questions_for_seller'] as List?) ?? [])
          .map((e) => e.toString())
          .toList(),
      safeAdvice: (json['safe_advice'] ?? '').toString(),
      safeAdviceUr: (json['safe_advice_ur'] ?? '').toString(),
    );
  }
}