import 'package:flutter/material.dart';
import 'package:vigil_ai/features/home/dashboard.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const VigilAIApp());
}

class VigilAIApp extends StatelessWidget {
  const VigilAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vigil AI',
      theme: VigilTheme.dark(),
      home: const Dashboard(),
    );
  }
}
