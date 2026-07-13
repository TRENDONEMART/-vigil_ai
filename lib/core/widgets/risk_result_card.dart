import 'package:flutter/material.dart';

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

  Color getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case "critical":
        return Colors.red.shade900;

      case "high":
        return Colors.red;

      case "medium":
        return Colors.orange;

      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Text(
                "Risk Score",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                "$riskScore / 100",
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: Chip(
                backgroundColor: getRiskColor(),
                label: Text(
                  riskLevel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Fraud Type",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              fraudType,
              style: const TextStyle(fontSize: 16),
            ),

            const Divider(height: 30),

            const Text(
              "Reasons",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            ...reasons.map(
                  (reason) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(reason),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 30),

            const Text(
              "Advice",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              advice,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 22),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy),
                    label: const Text("Copy"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}