class UpiResult {
  final String input;
  final bool isValid;
  final String validationMessage;
  final String? payeeAddress;
  final String? payeeName;
  final String? amount;
  final String? currency;
  final String? note;
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final List<String> reasons;
  final String advice;

  const UpiResult({
    required this.input,
    required this.isValid,
    required this.validationMessage,
    required this.payeeAddress,
    required this.payeeName,
    required this.amount,
    required this.currency,
    required this.note,
    required this.riskScore,
    required this.riskLevel,
    required this.fraudType,
    required this.reasons,
    required this.advice,
  });
}
