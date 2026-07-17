import 'package:flutter/material.dart';
import '../../core/widgets/risk_score_gauge.dart';
import '../../core/widgets/risk_level_chip.dart';
import '../../core/widgets/action_button_row.dart';
import '../../core/widgets/recommendation_card.dart';


class PremiumResultScreen extends StatelessWidget {
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final List<String> reasons;
  final String advice;

  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onScanAgain;
  RiskLevel _mapRiskLevel(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return RiskLevel.critical;
      case 'high':
        return RiskLevel.high;
      case 'medium':
        return RiskLevel.medium;
      case 'low':
        return RiskLevel.low;
      default:
        return RiskLevel.safe;
    }
  }

  const PremiumResultScreen({
    super.key,
    required this.riskScore,
    required this.riskLevel,
    required this.fraudType,
    required this.reasons,
    required this.advice,
    this.onCopy,
    this.onShare,
    this.onScanAgain,
  });

  Color get riskColor {
    switch (riskLevel.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.deepOrange;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Security Report"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    RiskScoreGauge(score: riskScore),
                    const SizedBox(height: 16),
                    RiskLevelChip(
                      level: _mapRiskLevel(riskLevel),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.security),
                title: const Text("Fraud Type"),
                subtitle: Text(fraudType),
              ),
            ),

            const SizedBox(height: 20),

            Column(
              children: reasons
                  .map(
                    (reason) => RecommendationCard(
                  icon: Icons.check_circle,
                  title: "Security Check",
                  description: reason,
                  color: Colors.blue,
                ),
              )
                  .toList(),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text("Recommendation"),
                subtitle: Text(advice),
              ),
            ),

            const SizedBox(height: 28),

        ActionButtonRow(
          onCopy: onCopy,
          onShare: onShare,
          onScanAgain: onScanAgain,
        ),
          ],
        ),
      ),
    );
  }
}