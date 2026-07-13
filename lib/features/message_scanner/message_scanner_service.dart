import '../../core/fraud_engine/fraud_engine.dart';
import 'message_result.dart';

class MessageScannerService {
  static MessageResult scan(String message) {
    final result = FraudEngine.analyze(message);

    return MessageResult(
      message: message,
      riskScore: result.riskScore,
      riskLevel: result.riskLevel,
      fraudType: result.fraudType,
      reasons: result.reasons,
      advice: result.advice,
    );
  }
}