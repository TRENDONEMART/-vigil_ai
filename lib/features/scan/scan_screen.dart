import 'package:flutter/material.dart';
import 'package:vigil_ai/features/apk_scanner/apk_scanner_screen.dart';
import 'package:vigil_ai/features/link_scanner/link_scanner_screen.dart';
import 'package:vigil_ai/features/message_scanner/message_scanner_screen.dart';
import 'package:vigil_ai/features/qr_scanner/qr_scanner_screen.dart';
import 'package:vigil_ai/features/upi_checker/upi_checker_screen.dart';

import '../../shared/widgets/premium_widgets.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      (
        'Message',
        'SMS and chat risk',
        Icons.sms_outlined,
        const MessageScannerScreen(),
      ),
      (
        'Link',
        'URL reputation check',
        Icons.link_outlined,
        const LinkScannerScreen(),
      ),
      (
        'QR code',
        'Camera or gallery scan',
        Icons.qr_code_scanner,
        const QrScannerScreen(),
      ),
      (
        'UPI',
        'Payment link safety',
        Icons.account_balance_wallet_outlined,
        const UpiCheckerScreen(),
      ),
      ('APK', 'App metadata review', Icons.android, const ApkScannerScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Scan center')),
      body: LayoutBuilder(
        builder: (context, constraints) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          children: [
            const PremiumPageIntro(
              eyebrow: 'Vigil AI tools',
              title: 'What would you like to check?',
              subtitle:
                  'Choose a scanner to get a clear, actionable risk assessment.',
              icon: Icons.radar_outlined,
            ),
            const SizedBox(height: 26),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tools.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 620 ? 3 : 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: constraints.maxWidth > 620 ? 1.15 : 1.02,
              ),
              itemBuilder: (context, index) {
                final tool = tools[index];
                return AnimatedFeatureTile(
                  title: tool.$1,
                  subtitle: tool.$2,
                  icon: tool.$3,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => tool.$4),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
