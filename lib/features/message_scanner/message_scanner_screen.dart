import 'package:flutter/material.dart';
import 'message_result.dart';
import 'message_scanner_service.dart';

class MessageScannerScreen extends StatefulWidget {
  const MessageScannerScreen({super.key});

  @override
  State<MessageScannerScreen> createState() => _MessageScannerScreenState();
}

class _MessageScannerScreenState extends State<MessageScannerScreen> {
  final TextEditingController controller = TextEditingController();

  MessageResult? result;

  void scanMessage() {
    setState(() {
      result = MessageScannerService.scan(controller.text);
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
        title: const Text("Message Scanner"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: "Paste SMS / WhatsApp Message",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: scanMessage,
                child: const Text("Analyze Message"),
              ),
            ),

            const SizedBox(height: 25),

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

                      const SizedBox(height: 15),

                      Text(
                        "Fraud Type: ${result!.fraudType}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
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