class FakeBrandDetector {
  static const Map<String, List<String>> _officialDomains = {
    'google': ['google.com', 'google.co.in'],
    'paypal': ['paypal.com'],
    'facebook': ['facebook.com', 'fb.com'],
    'instagram': ['instagram.com'],
    'amazon': ['amazon.com', 'amazon.in'],
    'whatsapp': ['whatsapp.com'],
    'sbi': ['sbi.co.in'],
    'hdfc': ['hdfcbank.com'],
    'icici': ['icicibank.com'],
    'paytm': ['paytm.com'],
    'phonepe': ['phonepe.com'],
  };

  static Map<String, dynamic> detect(String input) {
    final uri = Uri.tryParse(input.trim());
    final host = uri?.host.toLowerCase() ?? '';

    if (host.isEmpty) {
      return {'score': 0, 'reasons': <String>[]};
    }

    final normalizedHost = _normalizeLookalikes(host);
    final reasons = <String>[];
    var score = 0;

    for (final entry in _officialDomains.entries) {
      final brand = entry.key;
      final isOfficial = entry.value.any(
        (domain) => host == domain || host.endsWith('.$domain'),
      );

      if (!isOfficial && normalizedHost.contains(brand)) {
        score += 35;
        reasons.add(
          'Possible fake ${_capitalize(brand)} brand domain detected.',
        );
      }
    }

    return {'score': score, 'reasons': reasons};
  }

  static String _normalizeLookalikes(String value) {
    return value
        .replaceAll('0', 'o')
        .replaceAll('1', 'l')
        .replaceAll('3', 'e')
        .replaceAll('5', 's')
        .replaceAll('@', 'a');
  }

  static String _capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }
}
