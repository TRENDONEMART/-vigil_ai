import 'package:flutter/material.dart';

class PremiumResultScreen extends StatelessWidget {
  final int riskScore;
  final String riskLevel;
  final String fraudType;
  final List<String> reasons;
  final String advice;

  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onScanAgain;

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
                    Text(
                      "$riskScore",
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Risk Score",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 18),
                    Chip(
                      backgroundColor: riskColor,
                      label: Text(
                        riskLevel,
                        style: const TextStyle(color: Colors.white),
                      ),
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

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reasons",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...reasons.map(
                          (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

            FilledButton.icon(
              onPressed: onCopy,
              icon: const Icon(Icons.copy),
              label: const Text("Copy"),
            ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: onShare,
              icon: const Icon(Icons.share),
              label: const Text("Share"),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: onScanAgain,
              icon: const Icon(Icons.refresh),
              label: const Text("Scan Again"),
            ),
          ],
        ),
      ),
    );
  }
}