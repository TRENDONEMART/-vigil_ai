import 'package:flutter_test/flutter_test.dart';
import 'package:vigil_ai/features/upi_checker/upi_checker_service.dart';

void main() {
  test('validates a standard INR UPI payment link', () {
    final result = UpiCheckerService.check(
      'upi://pay?pa=merchant@upi&pn=Merchant&am=100&cu=INR',
    );

    expect(result.isValid, isTrue);
    expect(result.payeeAddress, 'merchant@upi');
    expect(result.amount, '100');
    expect(result.currency, 'INR');
  });

  test('rejects a payment link with an invalid payee address', () {
    final result = UpiCheckerService.check(
      'upi://pay?pa=not-a-vpa&am=100&cu=INR',
    );

    expect(result.isValid, isFalse);
    expect(result.validationMessage, contains('valid UPI ID'));
  });

  test('uses the fraud engine for suspicious UPI content', () {
    final result = UpiCheckerService.check(
      'upi://pay?pa=bank@upi&tn=urgent%20verify%20otp',
    );

    expect(result.riskScore, greaterThan(0));
    expect(result.reasons, isNotEmpty);
  });
}
