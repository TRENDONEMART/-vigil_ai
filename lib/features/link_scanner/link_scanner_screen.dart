import 'package:flutter/material.dart';
import 'link_scanner_service.dart';
import 'link_result.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Paste URL",
                border: OutlineInputBorder(),
                hintText: "https://example.com",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: scanLink,
                child: const Text("Analyze Link"),
              ),
            ),

            const SizedBox(height: 25),

            if (result != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Risk Score: ${result!.riskScore}/100",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        result!.riskLevel,
                        style: TextStyle(
                          fontSize: 18,
                          color: getRiskColor(result!.riskLevel),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(height: 30),

                      const Text(
                        "Reasons",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ...result!.reasons.map(
                            (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text("• $e"),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Advice",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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