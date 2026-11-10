class ScanResult {
  final int riskScore;
  final String riskLevel;
  final List<String> reasons;

  const ScanResult({
    required this.riskScore,
    required this.riskLevel,
    required this.reasons,
  });
}
