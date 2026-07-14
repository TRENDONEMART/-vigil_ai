import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/widgets/risk_result_card.dart';
import '../history/history_item.dart';
import '../history/history_service.dart';
import 'upi_checker_service.dart';
import 'upi_result.dart';

class UpiCheckerScreen extends StatefulWidget {
  const UpiCheckerScreen({super.key});

  @override
  State<UpiCheckerScreen> createState() => _UpiCheckerScreenState();
}

class _UpiCheckerScreenState extends State<UpiCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  UpiResult? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkUpi() async {
    final input = _controller.text.trim();

    if (input.isEmpty) {
      _showMessage('Paste a UPI payment link first.');
      return;
    }

    final result = UpiCheckerService.check(input);

    await HistoryService.addHistory(
      HistoryItem(
        type: 'UPI',
        input: result.input,
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

  void _clear() {
    _controller.clear();
    setState(() => _result = null);
  }

  String _shareText() {
    final result = _result!;
    final reasons = result.reasons.map((reason) => '- $reason').join('\n');

    return '''Vigil AI UPI Check

UPI Link:
${result.input}

Validation: ${result.validationMessage}
Risk: ${result.riskLevel} (${result.riskScore}/100)
Fraud Type: ${result.fraudType}

Reasons:
$reasons

Advice:
${result.advice}''';
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _shareText()));
    if (mounted) _showMessage('UPI result copied.');
  }

  Future<void> _share() =>
      Share.share(_shareText(), subject: 'Vigil AI UPI Check');

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return Scaffold(
      appBar: AppBar(title: const Text('UPI Checker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Check a UPI payment link before paying.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Paste the complete upi://pay link shared by the sender.',
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 6,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'UPI payment link',
                hintText: 'upi://pay?pa=merchant@upi&am=100&cu=INR',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _checkUpi,
              icon: const Icon(Icons.security),
              label: const Text('Check UPI Link'),
            ),
            if (result != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            result.isValid ? Icons.verified : Icons.warning,
                            color: result.isValid
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              result.validationMessage,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (result.payeeAddress != null) ...[
                        const SizedBox(height: 12),
                        Text('Payee: ${result.payeeAddress}'),
                      ],
                      if (result.payeeName?.isNotEmpty ?? false)
                        Text('Name: ${result.payeeName}'),
                      if (result.amount?.isNotEmpty ?? false)
                        Text(
                          'Amount: ${result.amount} ${result.currency ?? ''}',
                        ),
                      if (result.note?.isNotEmpty ?? false)
                        Text('Note: ${result.note}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              RiskResultCard(
                riskScore: result.riskScore,
                riskLevel: result.riskLevel,
                fraudType: result.fraudType,
                reasons: result.reasons,
                advice: result.advice,
                onCopy: _copy,
                onShare: _share,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.refresh),
                label: const Text('Check Another Link'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
