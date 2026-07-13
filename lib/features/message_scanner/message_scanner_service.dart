import 'message_result.dart';

class MessageScannerService {
  static MessageResult scan(String message) {
    final input = message.toLowerCase().trim();

    int score = 0;
    String fraudType = "Safe";
    List<String> reasons = [];

    if (input.isEmpty) {
      return const MessageResult(
        message: "",
        riskScore: 0,
        riskLevel: "Unknown",
        fraudType: "Unknown",
        reasons: ["Please enter a message."],
        advice: "Paste a message to analyze.",
      );
    }

    // Banking keywords
    final bankingWords = [
      "bank",
      "account",
      "sbi",
      "hdfc",
      "icici",
      "axis",
      "kotak",
    ];

    // Sensitive keywords
    final sensitiveWords = [
      "otp",
      "verify",
      "kyc",
      "pin",
      "cvv",
      "password",
      "login",
      "update",
      "blocked",
      "suspended",
    ];

    // Urgency words
    final urgencyWords = [
      "urgent",
      "immediately",
      "now",
      "today",
      "expire",
      "expires",
      "limited",
      "within",
    ];

    // Reward scam words
    final rewardWords = [
      "winner",
      "won",
      "gift",
      "reward",
      "lottery",
      "prize",
      "cashback",
      "free",
    ];

    // Scan Banking
    for (final word in bankingWords) {
      if (input.contains(word)) {
        score += 15;
        fraudType = "Banking Scam";
        reasons.add("Banking keyword detected: $word");
      }
    }

    // Scan Sensitive
    for (final word in sensitiveWords) {
      if (input.contains(word)) {
        score += 15;
        reasons.add("Sensitive keyword detected: $word");
      }
    }

    // Scan Urgency
    for (final word in urgencyWords) {
      if (input.contains(word)) {
        score += 10;
        reasons.add("Urgency tactic detected.");
      }
    }

    // Scan Rewards
    for (final word in rewardWords) {
      if (input.contains(word)) {
        score += 15;
        fraudType = "Reward Scam";
        reasons.add("Reward scam keyword detected.");
      }
    }

    // Detect Links
    if (input.contains("http://") ||
        input.contains("https://") ||
        input.contains("bit.ly") ||
        input.contains(".xyz")) {
      score += 25;
      reasons.add("Suspicious link detected.");
    }

    if (score > 100) {
      score = 100;
    }

    String level;

    if (score >= 70) {
      level = "High";
    } else if (score >= 40) {
      level = "Medium";
    } else {
      level = "Low";
    }

    return MessageResult(
      message: message,
      riskScore: score,
      riskLevel: level,
      fraudType: fraudType,
      reasons: reasons.isEmpty
          ? ["No obvious scam indicators found."]
          : reasons,
      advice: score >= 70
          ? "Do NOT share OTP, PIN, CVV or click suspicious links."
          : score >= 40
          ? "Verify the sender before taking any action."
          : "No obvious scam detected.",
    );
  }
}