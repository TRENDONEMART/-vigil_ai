import 'package:flutter/material.dart';

class RiskScoreGauge extends StatelessWidget {
  final int score;

  const RiskScoreGauge({
    super.key,
    required this.score,
  });

  Color get _color {
    if (score >= 80) return Colors.red;
    if (score >= 60) return Colors.deepOrange;
    if (score >= 35) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final progress = score / 100;

    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 170,
            height: 170,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation(_color),
                );
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$score",
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Risk Score",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}