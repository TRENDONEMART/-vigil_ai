import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SecurityTipCard extends StatelessWidget {
  final String title;
  final String tip;

  const SecurityTipCard({
    super.key,
    required this.title,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A2338),
            Color(0xFF101827),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VigilTheme.cyan.withValues(alpha: .15),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: VigilTheme.cyan,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  tip,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .70),
                    height: 1.45,
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