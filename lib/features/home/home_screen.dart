import 'package:flutter/material.dart';
import 'package:vigil_ai/features/link_scanner/link_scanner_screen.dart';
import 'package:vigil_ai/features/message_scanner/message_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        "title": "SMS Scam",
        "icon": Icons.sms,
      },
      {
        "title": "Link Scanner",
        "icon": Icons.link,
      },
      {
        "title": "QR Scanner",
        "icon": Icons.qr_code_scanner,
      },
      {
        "title": "UPI Check",
        "icon": Icons.account_balance_wallet,
      },
      {
        "title": "AI Advisor",
        "icon": Icons.smart_toy,
      },
      {
        "title": "APK Check",
        "icon": Icons.security,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Vigil AI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF00BCD4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Security Score",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "96 / 100",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "No Threat Detected",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: features.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final title = features[index]["title"] as String;
                final icon = features[index]["icon"] as IconData;

                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      switch (title) {
                        case "SMS Scam":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const MessageScannerScreen(),
                            ),
                          );
                          break;

                        case "Link Scanner":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const LinkScannerScreen(),
                            ),
                          );
                          break;

                        default:
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$title - Coming Soon"),
                            ),
                          );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.blue.shade50,
                          child: Icon(
                            icon,
                            color: Colors.blue,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}