import 'fake_brand_detector.dart';
import 'url_reputation.dart';

class ThreatDetector {
  static Map<String, dynamic> detect(String input) {
    final text = input.toLowerCase();

    int score = 0;
    String fraudType = "Safe";
    List<String> reasons = [];

    // ==========================
    // Banking Keywords
    // ==========================

    const bankingWords = [
      "bank",
      "account",
      "sbi",
      "hdfc",
      "icici",
      "axis",
      "kotak",
      "paytm",
      "phonepe",
      "gpay",
      "upi",
    ];

    for (final word in bankingWords) {
      if (text.contains(word)) {
        score += 15;
        fraudType = "Banking Scam";
        reasons.add("Banking keyword detected: $word");
      }
    }

    // ==========================
    // Sensitive Information
    // ==========================

    const sensitiveWords = [
      "otp",
      "pin",
      "cvv",
      "password",
      "login",
      "verify",
      "kyc",
      "update",
      "blocked",
      "suspended",
    ];

    for (final word in sensitiveWords) {
      if (text.contains(word)) {
        score += 15;
        reasons.add("Sensitive keyword detected: $word");
      }
    }

    // ==========================
    // Reward Scam
    // ==========================

    const rewardWords = [
      "winner",
      "won",
      "lottery",
      "gift",
      "reward",
      "cashback",
      "free",
      "prize",
    ];

    for (final word in rewardWords) {
      if (text.contains(word)) {
        score += 15;
        fraudType = "Reward Scam";
        reasons.add("Reward keyword detected: $word");
      }
    }

    // ==========================
    // Urgency
    // ==========================

    const urgencyWords = [
      "urgent",
      "immediately",
      "now",
      "today",
      "within",
      "expires",
      "expire",
    ];

    for (final word in urgencyWords) {
      if (text.contains(word)) {
        score += 10;
        reasons.add("Urgency tactic detected.");
      }
    }

    final urlResult = UrlReputation.evaluate(input);
    score += urlResult['score'] as int;
    reasons.addAll(List<String>.from(urlResult['reasons'] as List));

    final brandResult = FakeBrandDetector.detect(input);
    score += brandResult['score'] as int;
    reasons.addAll(List<String>.from(brandResult['reasons'] as List));

    if ((brandResult['score'] as int) > 0) {
      fraudType = 'Fake Brand Scam';
    } else if ((urlResult['score'] as int) > 0) {
      fraudType = 'Suspicious Link';
    }

    if (score > 100) {
      score = 100;
    }

    return {"score": score, "fraudType": fraudType, "reasons": reasons};
  }
}
