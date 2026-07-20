
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/widgets/premium_result_screen.dart';
import '../history/history_item.dart';
import '../history/history_service.dart';
import 'apk_result.dart';
import 'apk_scanner_service.dart';

class ApkScannerScreen extends StatefulWidget {
  const ApkScannerScreen({super.key});

  @override
  State<ApkScannerScreen> createState() => _ApkScannerScreenState();
}

class _ApkScannerScreenState extends State<ApkScannerScreen> {
  final TextEditingController _controller = TextEditingController();
  ApkResult? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final input = _controller.text.trim();

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paste APK metadata or permissions first.'),
        ),
      );
      return;
    }

    final result = ApkScannerService.scan(input);

    await HistoryService.addHistory(
      HistoryItem(
        type: 'APK',
        input: input,
        riskScore: result.riskScore,
        riskLevel: result.riskLevel,
        fraudType: result.fraudType,
        dateTime: DateTime.now(),
      ),
    );

    if (mounted) {
      setState(() => _result = result);
    }
  }

  String _reportText() {
    final result = _result!;
    final reasons = result.reasons.map((e) => '- $e').join('\n');

    return '''
Vigil AI APK Analysis

Risk Score: \${result.riskScore}/100
Risk Level: \${result.riskLevel}
Fraud Type: \${result.fraudType}

Reasons:
$reasons

Advice:
${result.advice}
''';
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _reportText()));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('APK report copied.')),
    );
  }

  Future<void> _share() async {
    await Share.share(
      _reportText(),
      subject: 'Vigil AI APK Analysis',
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return Scaffold(
      appBar: AppBar(title: const Text('APK Scanner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Review APK metadata before installing.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Paste the package name, permissions, publisher details, or download description. Analysis stays offline and does not install the APK.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              minLines: 6,
              maxLines: 12,
              decoration: const InputDecoration(
                labelText: 'APK metadata',
                hintText: 'Package: com.example.app\nPermissions: INTERNET, READ_SMS',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _scan,
              icon: const Icon(Icons.security),
              label: const Text('Analyze APK'),
            ),
            if (result != null) ...[
              const SizedBox(height: 22),
              if (result.suspiciousIndicators.isNotEmpty)
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Suspicious indicators',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...result.suspiciousIndicators.map(
                          (indicator) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('• \$indicator'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              PremiumResultScreen(
                riskScore: result.riskScore,
                riskLevel: result.riskLevel,
                fraudType: result.fraudType,
                reasons: result.reasons,
                advice: result.advice,
                reportText: _reportText(),
                onCopy: _copy,
                onShare: _share,
                onScanAgain: () {
                  _controller.clear();
                  setState(() => _result = null);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
