import 'package:flutter/material.dart';
import 'package:vigil_ai/features/history/history_screen.dart';
import 'package:vigil_ai/features/apk_scanner/apk_scanner_screen.dart';
import 'package:vigil_ai/features/link_scanner/link_scanner_screen.dart';
import 'package:vigil_ai/features/message_scanner/message_scanner_screen.dart';
import 'package:vigil_ai/features/qr_scanner/qr_scanner_screen.dart';
import 'package:vigil_ai/features/settings/settings_screen.dart';
import 'package:vigil_ai/features/upi_checker/upi_checker_screen.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/premium_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        "title": "SMS Scanner",
        "subtitle": "Detect risky messages",
        "icon": Icons.sms_outlined,
      },
      {
        "title": "Link Scanner",
        "subtitle": "Inspect a URL",
        "icon": Icons.link_outlined,
      },
      {
        "title": "QR Scanner",
        "subtitle": "Scan safely",
        "icon": Icons.qr_code_scanner,
      },
      {
        "title": "History",
        "subtitle": "Review your scans",
        "icon": Icons.history,
      },
      {
        "title": "UPI Check",
        "subtitle": "Verify payment links",
        "icon": Icons.account_balance_wallet_outlined,
      },
      {
        "title": "AI Advisor",
        "subtitle": "Security guidance",
        "icon": Icons.auto_awesome,
      },
      {
        "title": "APK Check",
        "subtitle": "Review app risk",
        "icon": Icons.android,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vigil AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  GradientSurface(
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your safety, at a glance',
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Stay one step ahead of scams',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Analyze suspicious content privately on your device.',
                                style: TextStyle(color: Colors.white60),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 62,
                          width: 62,
                          decoration: BoxDecoration(
                            color: VigilTheme.cyan.withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user_outlined,
                            color: VigilTheme.cyan,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Security tools',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final title = features[index]["title"] as String;
                  final subtitle = features[index]["subtitle"] as String;
                  final icon = features[index]["icon"] as IconData;
                  return AnimatedFeatureTile(
                    title: title,
                    subtitle: subtitle,
                    icon: icon,
                    onTap: () {
                      switch (title) {
                        case "SMS Scam":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MessageScannerScreen(),
                            ),
                          );
                          break;
                        case "Link Scanner":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LinkScannerScreen(),
                            ),
                          );
                          break;
                        case "QR Scanner":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QrScannerScreen(),
                            ),
                          );
                          break;
                        case "History":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HistoryScreen(),
                            ),
                          );
                          break;
                        case "UPI Check":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UpiCheckerScreen(),
                            ),
                          );
                          break;
                        case "APK Check":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ApkScannerScreen(),
                            ),
                          );
                          break;
                        default:
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("$title - Coming Soon")),
                          );
                      }
                    },
                  );
                }, childCount: features.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 620 ? 3 : 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: constraints.maxWidth > 620 ? 1.15 : 0.98,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }
}
