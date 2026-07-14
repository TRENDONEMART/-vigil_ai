class UrlReputation {
  static const Set<String> _shorteners = {
    'bit.ly',
    'tinyurl.com',
    't.co',
    'goo.gl',
    'is.gd',
    'ow.ly',
  };

  static const Set<String> _suspiciousTlds = {
    'xyz',
    'top',
    'click',
    'live',
    'shop',
    'buzz',
    'gq',
    'tk',
    'work',
    'zip',
  };

  static Map<String, dynamic> evaluate(String input) {
    final uri = Uri.tryParse(input.trim());
    final host = uri?.host.toLowerCase() ?? '';

    if (uri == null ||
        host.isEmpty ||
        !{'http', 'https'}.contains(uri.scheme)) {
      return {'score': 0, 'reasons': <String>[]};
    }

    final reasons = <String>[];
    var score = 0;

    if (uri.scheme == 'http') {
      score += 10;
      reasons.add('The link does not use encrypted HTTPS.');
    }

    if (host.startsWith('xn--') || host.contains('.xn--')) {
      score += 25;
      reasons.add('Internationalized or punycode domain detected.');
    }

    if (_shorteners.contains(host)) {
      score += 25;
      reasons.add('URL shortener hides the final destination.');
    }

    if (RegExp(r'^\d{1,3}(\.\d{1,3}){3}$').hasMatch(host)) {
      score += 20;
      reasons.add('The link points directly to an IP address.');
    }

    final tld = host.split('.').last;
    if (_suspiciousTlds.contains(tld)) {
      score += 30;
      reasons.add('Suspicious domain extension detected: .$tld');
    }

    if (uri.userInfo.isNotEmpty) {
      score += 30;
      reasons.add('The URL contains embedded login credentials.');
    }

    if (host.split('.').length > 4) {
      score += 10;
      reasons.add('Unusually deep subdomain structure detected.');
    }

    if (uri.hasPort && uri.port != 80 && uri.port != 443) {
      score += 10;
      reasons.add('The link uses a non-standard network port.');
    }

    return {'score': score, 'reasons': reasons};
  }
}
