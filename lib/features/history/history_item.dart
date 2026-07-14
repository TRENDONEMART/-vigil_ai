class HistoryItem {
  final String type;
  final String input;
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final DateTime dateTime;

  const HistoryItem({
    required this.type,
    required this.input,
    required this.riskScore,
    required this.riskLevel,
    required this.fraudType,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "input": input,
      "riskScore": riskScore,
      "riskLevel": riskLevel,
      "fraudType": fraudType,
      "dateTime": dateTime.toIso8601String(),
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      type: json["type"],
      input: json["input"],
      riskScore: json["riskScore"],
      riskLevel: json["riskLevel"],
      fraudType: json["fraudType"],
      dateTime: DateTime.parse(json["dateTime"]),
    );
  }
}
