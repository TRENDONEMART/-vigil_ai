import '../../core/fraud_engine/fraud_engine.dart';
import 'link_result.dart';

class LinkScannerService {
  static LinkResult scan(String url) {
    final result = FraudEngine.analyze(url);

    return LinkResult(
      url: url,
      riskScore: result.riskScore,
      riskLevel: result.riskLevel,
      reasons: result.reasons,
      advice: result.advice,
    );
  }
}