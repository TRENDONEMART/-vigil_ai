import 'package:flutter/material.dart';
import 'package:vigil_ai/features/home/dashboard.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
      ),
      home: const Dashboard(),
    );
  }
}