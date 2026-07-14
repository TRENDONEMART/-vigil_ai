import 'fraud_result.dart';
import 'risk_calculator.dart';
import 'threat_detector.dart';

class FraudEngine {
  static FraudResult analyze(String input) {
    final result = ThreatDetector.detect(input);

    final int score = result["score"] as int;
    final String fraudType = result["fraudType"] as String;
    final List<String> reasons = List<String>.from(result["reasons"] as List);

    final String level = RiskCalculator.calculateLevel(score);
    final String advice = RiskCalculator.getAdvice(score);

    return FraudResult(
      input: input,
      riskScore: score,
      riskLevel: level,
      fraudType: fraudType,
      reasons: reasons.isEmpty
          ? ["No obvious scam indicators detected."]
          : reasons,
      advice: advice,
    );
  }
}
