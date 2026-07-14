import 'package:flutter/material.dart';
import 'package:vigil_ai/features/apk_scanner/apk_scanner_screen.dart';
import 'package:vigil_ai/features/history/history_item.dart';
import 'package:vigil_ai/features/history/history_screen.dart';
import 'package:vigil_ai/features/history/history_service.dart';
import 'package:vigil_ai/features/link_scanner/link_scanner_screen.dart';
import 'package:vigil_ai/features/message_scanner/message_scanner_screen.dart';
import 'package:vigil_ai/features/qr_scanner/qr_scanner_screen.dart';
import 'package:vigil_ai/features/settings/settings_screen.dart';
import 'package:vigil_ai/features/upi_checker/upi_checker_screen.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated_slide_fade.dart';
import '../home/widgets/hero_section.dart';
import '../home/widgets/security_tip_card.dart';
import '../../shared/widgets/premium_widgets.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<HistoryItem>> _recentHistoryFuture;

  @override
  void initState() {
    super.initState();
    _recentHistoryFuture = HistoryService.getHistory();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _formatTimestamp(DateTime value) {
    final now = DateTime.now();
    final sameDay = value.year == now.year && value.month == now.month && value.day == now.day;

    if (sameDay) {
      final hour = value.hour.toString().padLeft(2, '0');
      final minute = value.minute.toString().padLeft(2, '0');
      return 'Today • $hour:$minute';
    }

    return '${value.day}/${value.month}/${value.year}';
  }

  void _openFeature(BuildContext context, String title) {
    switch (title) {
      case 'SMS Scanner':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MessageScannerScreen()),
        );
        break;
      case 'Link Scanner':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LinkScannerScreen()),
        );
        break;
      case 'QR Scanner':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QrScannerScreen()),
        );
        break;
      case 'UPI Checker':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UpiCheckerScreen()),
        );
        break;
      case 'APK Scanner':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ApkScannerScreen()),
        );
        break;
      case 'History':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HistoryScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title - Coming Soon')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'title': 'SMS Scanner',
        'subtitle': 'Detect risky SMS',
        'icon': Icons.sms_outlined,
      },
      {
        'title': 'Link Scanner',
        'subtitle': 'Inspect suspicious URLs',
        'icon': Icons.link_outlined,
      },
      {
        'title': 'QR Scanner',
        'subtitle': 'Scan safely',
        'icon': Icons.qr_code_scanner,
      },
      {
        'title': 'UPI Checker',
        'subtitle': 'Verify payment links',
        'icon': Icons.account_balance_wallet_outlined,
      },
      {
        'title': 'APK Scanner',
        'subtitle': 'Review app risk',
        'icon': Icons.android,
      },
      {
        'title': 'History',
        'subtitle': 'Review your scans',
        'icon': Icons.history,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vigil AI'),
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GradientSurface(
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting(),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.74),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Your safety is protected in real time',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Private offline analysis keeps your scans secure and local.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 54,
                        width: 54,
                        decoration: BoxDecoration(
                          color: VigilTheme.cyan.withValues(alpha: 0.16),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: VigilTheme.cyan,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AnimatedSlideFadeIn(
                  child: const HeroSection(),
                ),
                const SizedBox(height: 24),
                AnimatedSlideFadeIn(
                  delay: const Duration(milliseconds: 60),
                  child: _SectionHeader(
                    title: 'Quick Actions',
                    subtitle: 'Jump into the tool you need',
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth >= 680 ? 3 : 2;
                    return AnimatedSlideFadeIn(
                      delay: const Duration(milliseconds: 120),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: features.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.02,
                        ),
                        itemBuilder: (context, index) {
                          final title = features[index]['title'] as String;
                          final subtitle = features[index]['subtitle'] as String;
                          final icon = features[index]['icon'] as IconData;

                          return AnimatedSlideFadeIn(
                            delay: Duration(milliseconds: 160 + index * 50),
                            child: AnimatedFeatureTile(
                              title: title,
                              subtitle: subtitle,
                              icon: icon,
                              onTap: () => _openFeature(context, title),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                AnimatedSlideFadeIn(
                  delay: const Duration(milliseconds: 120),
                  child: _SectionHeader(
                    title: 'Recent Activity',
                    subtitle: 'Your latest scan results',
                  ),
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<HistoryItem>>(
                  future: _recentHistoryFuture,
                  builder: (context, snapshot) {
                    Widget content;
                    if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                      content = const _RecentActivityCard(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.6),
                            ),
                          ),
                        ),
                      );
                    } else {
                      final history = snapshot.data ?? <HistoryItem>[];
                      if (history.isEmpty) {
                        content = const _RecentActivityCard(
                          child: Padding(
                            padding: EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No scans yet',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Your latest detections will appear here once you run a scan.',
                                  style: TextStyle(height: 1.45, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        content = Column(
                          children: history.take(3).map((item) {
                            final index = history.take(3).toList().indexOf(item);
                            return AnimatedSlideFadeIn(
                              delay: Duration(milliseconds: 70 + index * 60),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ActivityRow(
                                  title: item.type,
                                  subtitle: item.fraudType.isNotEmpty ? item.fraudType : 'Scan completed',
                                  badge: item.riskLevel,
                                  timestamp: _formatTimestamp(item.dateTime),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }

                    return content;
                  },
                ),
                const SizedBox(height: 24),
                AnimatedSlideFadeIn(
                  delay: const Duration(milliseconds: 120),
                  child: const SecurityTipCard(
                    title: 'AI Security Tip',
                    tip: 'Hover before you tap. Check the sender, link, and payment request before acting on any urgent alert.',
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.62)),
        ),
      ],
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final Widget child;

  const _RecentActivityCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            VigilTheme.cyan.withValues(alpha: 0.18),
            VigilTheme.violet.withValues(alpha: 0.16),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF131C2E),
          borderRadius: BorderRadius.circular(22),
        ),
        child: child,
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final String timestamp;

  const _ActivityRow({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.timestamp,
  });

  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return const Color(0xFFFF5574);
      case 'high':
        return const Color(0xFFFF8066);
      case 'medium':
        return const Color(0xFFFFC857);
      default:
        return VigilTheme.cyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(badge);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.security_outlined, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.66)),
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.44),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

