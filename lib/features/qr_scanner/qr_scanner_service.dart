import '../../core/fraud_engine/fraud_engine.dart';
import 'qr_result.dart';

class QrScannerService {
  static QrResult scan(String qrData) {
    final result = FraudEngine.analyze(qrData);

    return QrResult(
      rawValue: qrData,
      riskScore: result.riskScore,
      riskLevel: result.riskLevel,
      fraudType: result.fraudType,
      reasons: result.reasons,
      advice: result.advice,
    );
  }
}
