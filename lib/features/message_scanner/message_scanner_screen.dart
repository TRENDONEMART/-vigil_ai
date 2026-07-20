
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/widgets/premium_result_screen.dart';
import '../../shared/widgets/premium_widgets.dart';
import '../history/history_item.dart';
import '../history/history_service.dart';
import 'message_result.dart';
import 'message_scanner_service.dart';

class MessageScannerScreen extends StatefulWidget {
  const MessageScannerScreen({super.key});

  @override
  State<MessageScannerScreen> createState() => _MessageScannerScreenState();
}

class _MessageScannerScreenState extends State<MessageScannerScreen> {
  final TextEditingController controller = TextEditingController();
  MessageResult? result;

  Future<void> scanMessage() async {
    final messageResult = MessageScannerService.scan(controller.text);

    await HistoryService.addHistory(
      HistoryItem(
        type: 'Message',
        input: controller.text.trim(),
        riskScore: messageResult.riskScore,
        riskLevel: messageResult.riskLevel,
        fraudType: messageResult.fraudType,
        dateTime: DateTime.now(),
      ),
    );

    if (!mounted) return;

    setState(() {
      result = messageResult;
    });
  }

  String _reportText() {
    final message = result!;
    final reasons = message.reasons.map((e) => '- $e').join('\n');

    return '''
Vigil AI Message Analysis

Risk Score: ${message.riskScore}/100
Risk Level: ${message.riskLevel}
Fraud Type: ${message.fraudType}

Reasons:
$reasons

Advice:
${message.advice}
''';
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _reportText()));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message report copied.')),
    );
  }

  Future<void> _share() async {
    await Share.share(
      _reportText(),
      subject: 'Vigil AI Message Analysis',
    );
  }

  void _scanAgain() {
    controller.clear();
    setState(() {
      result = null;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message scanner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PremiumPageIntro(
              eyebrow: 'Private analysis',
              title: 'Inspect a message',
              subtitle:
                  'Spot urgency, impersonation, and sensitive-data requests before you respond.',
              icon: Icons.sms_outlined,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'SMS or WhatsApp message',
                hintText: 'Paste the message you want to review…',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: scanMessage,
              icon: const Icon(Icons.shield_outlined),
              label: const Text('Analyze message'),
            ),
            if (result != null) ...[
              const SizedBox(height: 24),
              PremiumResultScreen(
                riskScore: result!.riskScore,
                riskLevel: result!.riskLevel,
                fraudType: result!.fraudType,
                reasons: result!.reasons,
                advice: result!.advice,
                reportText: _reportText(),
                onCopy: _copy,
                onShare: _share,
                onScanAgain: _scanAgain,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
