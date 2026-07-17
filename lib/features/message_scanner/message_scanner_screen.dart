import 'package:flutter/material.dart';

import '../../core/widgets/risk_result_card.dart';
import '../../shared/widgets/premium_widgets.dart';
import 'message_result.dart';
import 'message_scanner_service.dart';
import '../history/history_item.dart';
import '../history/history_service.dart';

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
              RiskResultCard(
                riskScore: result!.riskScore,
                riskLevel: result!.riskLevel,
                fraudType: result!.fraudType,
                reasons: result!.reasons,
                advice: result!.advice,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
