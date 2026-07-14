import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/premium_widgets.dart';
import 'risk_result_card.dart';

class ResultShell extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final Widget inputContent;
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final List<String> reasons;
  final String advice;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  const ResultShell({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.inputContent,
    required this.riskScore,
    required this.riskLevel,
    required this.fraudType,
    required this.reasons,
    required this.advice,
    this.onCopy,
    this.onShare,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  Color get _riskColor {
    switch (riskLevel.toLowerCase()) {
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
    return GradientSurface(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        VigilTheme.cyan,
                        VigilTheme.violet,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF07121C),
                    size: 27,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.58),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _riskColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _riskColor.withValues(alpha: 0.25),
                      width: 0.6,
                    ),
                  ),
                  child: Text(
                    '$riskScore/100 • ${riskLevel[0].toUpperCase()}${riskLevel.substring(1)}',
                    style: TextStyle(
                      color: _riskColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            inputContent,

            const SizedBox(height: 18),

            RiskResultCard(
              riskScore: riskScore,
              riskLevel: riskLevel,
              fraudType: fraudType,
              reasons: reasons,
              advice: advice,
              onCopy: onCopy,
              onShare: onShare,
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onPrimaryAction,
                    child: Text(primaryActionLabel),
                  ),
                ),
                if (secondaryActionLabel != null &&
                    onSecondaryAction != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSecondaryAction,
                      icon: const Icon(Icons.refresh_outlined),
                      label: Text(secondaryActionLabel!),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}