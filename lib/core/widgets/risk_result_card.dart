import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RiskResultCard extends StatelessWidget {
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final List<String> reasons;
  final String advice;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  const RiskResultCard({
    super.key,
    required this.riskScore,
    required this.riskLevel,
    required this.fraudType,
    required this.reasons,
    required this.advice,
    this.onCopy,
    this.onShare,
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
    return Card(
      color: VigilTheme.surfaceElevated,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Risk assessment',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(Icons.insights_outlined, color: _riskColor),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$riskScore',
                  style: TextStyle(
                    color: _riskColor,
                    fontSize: 48,
                    height: 0.95,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 6),
                  child: Text('/ 100', style: TextStyle(color: Colors.white54)),
                ),
                const Spacer(),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: _riskColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      riskLevel,
                      style: TextStyle(
                        color: _riskColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: riskScore.clamp(0, 100) / 100,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                color: _riskColor,
              ),
            ),
            const SizedBox(height: 22),
            _LabelValue(label: 'Classification', value: fraudType),
            const SizedBox(height: 18),
            const Text(
              'Why this matters',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ...reasons.map(
              (reason) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: _riskColor,
                      size: 18,
                    ),
                    const SizedBox(width: 9),
                    Expanded(child: Text(reason)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.045),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(advice, style: const TextStyle(height: 1.4)),
            ),
            if (onCopy != null || onShare != null) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  if (onCopy != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onCopy,
                        icon: const Icon(Icons.copy_outlined),
                        label: const Text('Copy'),
                      ),
                    ),
                  if (onCopy != null && onShare != null)
                    const SizedBox(width: 10),
                  if (onShare != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onShare,
                        icon: const Icon(Icons.ios_share_outlined),
                        label: const Text('Share'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;

  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
