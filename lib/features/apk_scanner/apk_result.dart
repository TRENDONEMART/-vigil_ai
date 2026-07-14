class ApkResult {
  final String input;
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final List<String> reasons;
  final String advice;
  final List<String> suspiciousIndicators;

  const ApkResult({
    required this.input,
    required this.riskScore,
    required this.riskLevel,
    required this.fraudType,
    required this.reasons,
    required this.advice,
    required this.suspiciousIndicators,
  });
}
