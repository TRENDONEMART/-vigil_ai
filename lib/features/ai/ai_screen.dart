import 'package:flutter/material.dart';

import '../../shared/widgets/premium_widgets.dart';

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI advisor')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
        children: [
          const PremiumPageIntro(
            eyebrow: 'Coming soon',
            title: 'Your security co-pilot',
            subtitle: 'A calm, intelligent guide for making safer decisions.',
            icon: Icons.auto_awesome,
          ),
          const SizedBox(height: 26),
          GradientSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.forum_outlined, color: Colors.white, size: 32),
                const SizedBox(height: 18),
                Text(
                  'Ask better questions',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The AI advisor will help explain suspicious messages, links, and payment requests in plain language.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text(
                'Privacy first',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text(
                'Your current scanners already work offline on this device.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
