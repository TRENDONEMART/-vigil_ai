import 'package:flutter/material.dart';
import 'link_result.dart';
import 'link_scanner_service.dart';

class LinkScannerScreen extends StatefulWidget {
  const LinkScannerScreen({super.key});

  @override
  State<LinkScannerScreen> createState() => _LinkScannerScreenState();
}

class _LinkScannerScreenState extends State<LinkScannerScreen> {
  final TextEditingController controller = TextEditingController();

  LinkResult? result;

  void scanLink() {
    setState(() {
      result = LinkScannerService.scan(controller.text);
    });
  }

  Color getRiskColor(String level) {
    switch (level) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Link Scanner"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Paste URL",
                hintText: "https://example.com",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: scanLink,
                child: const Text("Analyze Link"),
              ),
            ),

            const SizedBox(height: 20),

            if (result != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Risk Score: ${result!.riskScore}/100",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Chip(
                        backgroundColor: getRiskColor(result!.riskLevel),
                        label: Text(
                          result!.riskLevel,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Reasons",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ...result!.reasons.map(
                            (reason) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text("• $reason"),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Advice",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(result!.advice),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}