class QrResult {
  final String rawValue;
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final List<String> reasons;
  final String advice;

  const QrResult({
    required this.rawValue,
    required this.riskScore,
    required this.riskLevel,
    required this.fraudType,
    required this.reasons,
    required this.advice,
  });
}
