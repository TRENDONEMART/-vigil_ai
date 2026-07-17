import 'package:flutter/material.dart';

import '../../core/widgets/risk_result_card.dart';
import '../../shared/widgets/premium_widgets.dart';
import '../../shared/widgets/premium_result_screen.dart';
import 'link_result.dart';
import 'link_scanner_service.dart';
import '../history/history_item.dart';
import '../history/history_service.dart';

class LinkScannerScreen extends StatefulWidget {
  const LinkScannerScreen({super.key});

  @override
  State<LinkScannerScreen> createState() => _LinkScannerScreenState();
}

class _LinkScannerScreenState extends State<LinkScannerScreen> {
  final TextEditingController controller = TextEditingController();
  LinkResult? result;

  Future<void> scanLink() async {
    final linkResult = LinkScannerService.scan(controller.text);

    await HistoryService.addHistory(
      HistoryItem(
        type: 'Link',
        input: controller.text.trim(),
        riskScore: linkResult.riskScore,
        riskLevel: linkResult.riskLevel,
        fraudType: 'Link Analysis',
        dateTime: DateTime.now(),
      ),
    );

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PremiumResultScreen(
          riskScore: linkResult.riskScore,
          riskLevel: linkResult.riskLevel,
          fraudType: 'Link Analysis',
          reasons: linkResult.reasons,
          advice: linkResult.advice,
          onCopy: () {},
          onShare: () {},
          onScanAgain: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Link scanner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PremiumPageIntro(
              eyebrow: 'Reputation check',
              title: 'Inspect a link',
              subtitle: 'Understand a URL’s risk signals before opening it.',
              icon: Icons.link_outlined,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'URL to analyze',
                hintText: 'https://example.com',
                prefixIcon: Icon(Icons.language),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: scanLink,
              icon: const Icon(Icons.search),
              label: const Text('Analyze link'),
            ),
            if (result != null) ...[
              const SizedBox(height: 24),
              RiskResultCard(
                riskScore: result!.riskScore,
                riskLevel: result!.riskLevel,
                fraudType: 'Link analysis',
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
