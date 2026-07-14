class FraudResult {
  final String input;
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final List<String> reasons;
  final String advice;

  const FraudResult({
    required this.input,
    required this.riskScore,
    required this.riskLevel,
    required this.fraudType,
    required this.reasons,
    required this.advice,
  });

  factory FraudResult.safe([String input = ""]) {
    return FraudResult(
      input: input,
      riskScore: 0,
      riskLevel: "Low",
      fraudType: "Safe",
      reasons: const [
        "No obvious scam indicators detected.",
      ],
      advice: "No obvious risk detected.",
    );
  }

  bool get isLow => riskScore < 35;

  bool get isMedium => riskScore >= 35 && riskScore < 60;

  bool get isHigh => riskScore >= 60 && riskScore < 80;

  bool get isCritical => riskScore >= 80;
}