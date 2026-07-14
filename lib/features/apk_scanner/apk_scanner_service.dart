import '../../core/fraud_engine/fraud_engine.dart';
import 'apk_result.dart';

class ApkScannerService {
  static ApkResult scan(String metadata) {
    final input = metadata.trim();
    final analysis = FraudEngine.analyze(input);
    final indicators = <String>[];
    final text = input.toLowerCase();

    const dangerousPermissions = {
      'request_install_packages': 'Can install other applications.',
      'system_alert_window': 'Can draw over other applications.',
      'read_sms': 'Can read SMS messages.',
      'receive_sms': 'Can receive SMS messages.',
      'bind_accessibility_service': 'Can control accessibility services.',
      'query_all_packages': 'Can inspect all installed applications.',
      'read_call_log': 'Can read call history.',
    };

    for (final entry in dangerousPermissions.entries) {
      if (text.contains(entry.key)) {
        indicators.add(entry.value);
      }
    }

    if (text.contains('unknown source') || text.contains('unknown sources')) {
      indicators.add('The package is marked as coming from an unknown source.');
    }

    if (text.contains('cracked') ||
        text.contains('mod apk') ||
        text.contains('premium unlocked')) {
      indicators.add(
        'The package description suggests a modified or cracked APK.',
      );
    }

    var score = analysis.riskScore + indicators.length * 10;
    if (score > 100) score = 100;

    return ApkResult(
      input: input,
      riskScore: score,
      riskLevel: _level(score),
      fraudType: indicators.isEmpty ? analysis.fraudType : 'Suspicious APK',
      reasons: [
        ...analysis.reasons,
        ...indicators.map((indicator) => 'APK indicator: $indicator'),
      ],
      advice: score >= 60
          ? 'Do not install this APK unless you can independently verify its publisher and source.'
          : analysis.advice,
      suspiciousIndicators: indicators,
    );
  }

  static String _level(int score) {
    if (score >= 80) return 'Critical';
    if (score >= 60) return 'High';
    if (score >= 35) return 'Medium';
    return 'Low';
  }
}
