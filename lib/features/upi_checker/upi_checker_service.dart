import '../../core/fraud_engine/fraud_engine.dart';
import 'upi_result.dart';

class UpiCheckerService {
  static UpiResult check(String input) {
    final value = input.trim();
    final analysis = FraudEngine.analyze(value);

    String? payeeAddress;
    String? payeeName;
    String? amount;
    String? currency;
    String? note;
    String validationMessage = 'Enter a UPI payment link.';
    var isValid = false;

    try {
      final uri = Uri.parse(value);
      final parameters = uri.queryParameters;
      final address = parameters['pa']?.trim();
      final parsedAmount = parameters['am']?.trim();
      final parsedCurrency = parameters['cu']?.trim().toUpperCase();

      payeeAddress = address;
      payeeName = parameters['pn']?.trim();
      amount = parsedAmount;
      currency = parsedCurrency;
      note = parameters['tn']?.trim();

      final hasUpiScheme = uri.scheme.toLowerCase() == 'upi';
      final hasPayHost = uri.host.toLowerCase() == 'pay';
      final hasValidAddress = address != null && _isValidVpa(address);
      final hasValidAmount =
          parsedAmount == null ||
          (double.tryParse(parsedAmount) != null &&
              double.parse(parsedAmount) > 0);
      final hasValidCurrency =
          parsedCurrency == null || parsedCurrency == 'INR';

      if (!hasUpiScheme || !hasPayHost) {
        validationMessage = 'This is not a valid upi://pay payment link.';
      } else if (!hasValidAddress) {
        validationMessage = 'The payment link does not contain a valid UPI ID.';
      } else if (!hasValidAmount) {
        validationMessage = 'The payment amount is invalid.';
      } else if (!hasValidCurrency) {
        validationMessage = 'Only INR payments are supported.';
      } else {
        isValid = true;
        validationMessage = 'Valid UPI payment link.';
      }
    } catch (_) {
      validationMessage = 'The entered value is not a readable UPI link.';
    }

    return UpiResult(
      input: value,
      isValid: isValid,
      validationMessage: validationMessage,
      payeeAddress: payeeAddress,
      payeeName: payeeName,
      amount: amount,
      currency: currency,
      note: note,
      riskScore: analysis.riskScore,
      riskLevel: analysis.riskLevel,
      fraudType: analysis.fraudType,
      reasons: analysis.reasons,
      advice: analysis.advice,
    );
  }

  static bool _isValidVpa(String value) {
    return RegExp(r'^[A-Za-z0-9._-]{2,}@[A-Za-z0-9.-]{2,}$').hasMatch(value);
  }
}
