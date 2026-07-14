import 'package:flutter/material.dart';
import 'package:vigil_ai/features/history/history_screen.dart';
import 'package:vigil_ai/features/link_scanner/link_scanner_screen.dart';
import 'package:vigil_ai/features/message_scanner/message_scanner_screen.dart';
import 'package:vigil_ai/features/qr_scanner/qr_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {"title":"SMS Scam","icon":Icons.sms},
      {"title":"Link Scanner","icon":Icons.link},
      {"title":"QR Scanner","icon":Icons.qr_code_scanner},
      {"title":"History","icon":Icons.history},
      {"title":"UPI Check","icon":Icons.account_balance_wallet},
      {"title":"AI Advisor","icon":Icons.smart_toy},
      {"title":"APK Check","icon":Icons.security},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vigil AI",style:TextStyle(fontWeight:FontWeight.bold)),
        centerTitle:true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:2,
            crossAxisSpacing:16,
            mainAxisSpacing:16,
            childAspectRatio:1,
          ),
          itemBuilder:(context,index){
            final title=features[index]["title"] as String;
            final icon=features[index]["icon"] as IconData;
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap:(){
                  switch(title){
                    case "SMS Scam":
                      Navigator.push(context,MaterialPageRoute(builder:(_)=>const MessageScannerScreen()));
                      break;
                    case "Link Scanner":
                      Navigator.push(context,MaterialPageRoute(builder:(_)=>const LinkScannerScreen()));
                      break;
                    case "QR Scanner":
                      Navigator.push(context,MaterialPageRoute(builder:(_)=>const QrScannerScreen()));
                      break;
                    case "History":
                      Navigator.push(context,MaterialPageRoute(builder:(_)=>const HistoryScreen()));
                      break;
                    default:
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content:Text("$title - Coming Soon")),
                      );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Icon(icon,size:42),
                    const SizedBox(height:12),
                    Text(title,textAlign:TextAlign.center,style:const TextStyle(fontWeight:FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
