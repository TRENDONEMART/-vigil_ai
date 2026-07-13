class FraudResult {
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final List<String> reasons;
  final String advice;

  const FraudResult({
    required this.riskScore,
    required this.riskLevel,
    required this.fraudType,
    required this.reasons,
    required this.advice,
  });

  factory FraudResult.safe() {
    return const FraudResult(
      riskScore: 0,
      riskLevel: "Low",
      fraudType: "Safe",
      reasons: [
        "No obvious scam indicators detected.",
      ],
      advice: "No obvious risk detected.",
    );
  }
}