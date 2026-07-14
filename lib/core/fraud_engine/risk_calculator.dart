class RiskCalculator {
  static String calculateLevel(int score) {
    if (score >= 80) {
      return "Critical";
    }

    if (score >= 60) {
      return "High";
    }

    if (score >= 35) {
      return "Medium";
    }

    return "Low";
  }

  static String getAdvice(int score) {
    if (score >= 80) {
      return "Do NOT click links, share OTP, PIN, CVV or personal information. This appears highly suspicious.";
    }

    if (score >= 60) {
      return "Verify the sender before taking any action. Avoid sharing sensitive information.";
    }

    if (score >= 35) {
      return "Proceed carefully. Verify the source independently.";
    }

    return "No obvious scam indicators detected. Stay cautious.";
  }
}
