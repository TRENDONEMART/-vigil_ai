import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose what you want to scan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            ListTile(
              leading: const Icon(Icons.sms),
              title: const Text("Scan Message"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.link),
              title: const Text("Scan Link"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text("Scan QR Code"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.security),
              title: const Text("Scan APK"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}