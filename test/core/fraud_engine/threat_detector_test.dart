import 'package:flutter_test/flutter_test.dart';
import 'package:vigil_ai/core/fraud_engine/fraud_engine.dart';

void main() {
  test('detects suspicious URL reputation signals', () {
    final result = FraudEngine.analyze('http://login.example.xyz');

    expect(result.riskScore, greaterThan(0));
    expect(result.reasons.join(' '), contains('domain extension'));
  });

  test('detects fake brand impersonation domains', () {
    final result = FraudEngine.analyze('https://paypa1-security.com/login');

    expect(result.fraudType, 'Fake Brand Scam');
    expect(result.reasons.join(' '), contains('fake Paypal'));
  });

  test('does not flag the official brand domain as fake', () {
    final result = FraudEngine.analyze('https://www.paypal.com');

    expect(result.reasons.join(' '), isNot(contains('fake Paypal')));
  });
}
