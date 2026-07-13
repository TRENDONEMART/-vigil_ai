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

    // ==========================
    // Links
    // ==========================

    if (text.contains("http://") ||
        text.contains("https://") ||
        text.contains("bit.ly") ||
        text.contains(".xyz")) {
      score += 25;
      reasons.add("Suspicious link detected.");
    }

    // ==========================
    // Fake Brands
    // ==========================

    const brands = [
      "google",
      "paypal",
      "facebook",
      "instagram",
      "amazon",
      "whatsapp",
      "sbi",
      "hdfc",
      "icici",
    ];

    for (final brand in brands) {
      if (text.contains("$brand-") ||
          text.contains("-$brand")) {
        score += 35;
        reasons.add("Possible fake brand impersonation.");
      }
    }

    // ==========================
    // Dangerous TLD
    // ==========================

    const tlds = [
      ".xyz",
      ".top",
      ".click",
      ".live",
      ".shop",
      ".buzz",
      ".gq",
      ".tk",
    ];

    for (final tld in tlds) {
      if (text.contains(tld)) {
        score += 30;
        reasons.add("Suspicious domain extension: $tld");
      }
    }

    if (score > 100) {
      score = 100;
    }

    return {
      "score": score,
      "fraudType": fraudType,
      "reasons": reasons,
    };
  }
}