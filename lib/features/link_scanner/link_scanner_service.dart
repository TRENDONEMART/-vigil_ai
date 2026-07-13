import 'link_result.dart';

class LinkScannerService {
  static LinkResult scan(String url) {
    final input = url.trim().toLowerCase();

    int score = 0;
    List<String> reasons = [];

    // Empty input
    if (input.isEmpty) {
      return const LinkResult(
        url: "",
        riskScore: 0,
        riskLevel: "Unknown",
        reasons: ["Please enter a link"],
        advice: "Paste a valid URL.",
      );
    }

    // HTTP instead of HTTPS
    if (input.startsWith("http://")) {
      score += 20;
      reasons.add("Website is not using HTTPS.");
    }

    // Shortened URLs
    final shorteners = [
      "bit.ly",
      "tinyurl",
      "cutt.ly",
      "goo.gl",
      "is.gd",
      "t.ly",
      "rb.gy",
      "ow.ly",
    ];

    for (final domain in shorteners) {
      if (input.contains(domain)) {
        score += 30;
        reasons.add("Shortened URL detected.");
        break;
      }
    }

    // Suspicious words
    final suspiciousWords = [
      "login",
      "verify",
      "bank",
      "wallet",
      "otp",
      "gift",
      "reward",
      "claim",
      "free",
      "prize",
      "update",
      "kyc",
      "upi",
      "pay",
    ];

    for (final word in suspiciousWords) {
      if (input.contains(word)) {
        score += 8;
        reasons.add("Contains suspicious keyword: $word");
      }
    }

    // IP Address instead of domain
    final ipRegex =
    RegExp(r'http[s]?:\/\/(\d{1,3}\.){3}\d{1,3}');
    if (ipRegex.hasMatch(input)) {
      score += 35;
      reasons.add("Uses IP address instead of domain.");
    }

    // Too long URL
    if (input.length > 120) {
      score += 10;
      reasons.add("Very long URL.");
    }

    if (score > 100) score = 100;

    String level;

    if (score >= 70) {
      level = "High";
    } else if (score >= 40) {
      level = "Medium";
    } else {
      level = "Low";
    }

    return LinkResult(
      url: url,
      riskScore: score,
      riskLevel: level,
      reasons: reasons.isEmpty
          ? ["No obvious threat found."]
          : reasons,
      advice: score >= 70
          ? "Avoid opening this link."
          : score >= 40
          ? "Open carefully after verification."
          : "Looks reasonably safe.",
    );
  }
}