class LinkResult {
  final String url;
  final int riskScore;
  final String riskLevel;
  final List<String> reasons;
  final String advice;

  const LinkResult({
    required this.url,
    required this.riskScore,
    required this.riskLevel,
    required this.reasons,
    required this.advice,
  });
}
