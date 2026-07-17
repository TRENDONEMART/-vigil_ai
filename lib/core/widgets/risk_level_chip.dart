import 'package:flutter/material.dart';

enum RiskLevel {
  safe,
  low,
  medium,
  high,
  critical,
}

class RiskLevelChip extends StatelessWidget {
  final RiskLevel level;

  const RiskLevelChip({
    super.key,
    required this.level,
  });

  Color get color {
    switch (level) {
      case RiskLevel.safe:
        return Colors.green;
      case RiskLevel.low:
        return Colors.lightGreen;
      case RiskLevel.medium:
        return Colors.orange;
      case RiskLevel.high:
        return Colors.deepOrange;
      case RiskLevel.critical:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (level) {
      case RiskLevel.safe:
        return Icons.verified_rounded;
      case RiskLevel.low:
        return Icons.check_circle_outline_rounded;
      case RiskLevel.medium:
        return Icons.warning_amber_rounded;
      case RiskLevel.high:
        return Icons.error_outline_rounded;
      case RiskLevel.critical:
        return Icons.gpp_bad_rounded;
    }
  }

  String get text {
    switch (level) {
      case RiskLevel.safe:
        return "SAFE";
      case RiskLevel.low:
        return "LOW RISK";
      case RiskLevel.medium:
        return "MEDIUM RISK";
      case RiskLevel.high:
        return "HIGH RISK";
      case RiskLevel.critical:
        return "CRITICAL";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}