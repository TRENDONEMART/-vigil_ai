
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/widgets/risk_result_card.dart';
import '../history/history_item.dart';
import '../history/history_service.dart';
import 'qr_result.dart';
import 'qr_scanner_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});
  @override
  State<QrScannerScreen> createState()=>_QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>{
  final controller=MobileScannerController();
  bool scanned=false;
  bool flashOn=false;
  QrResult? result;

  Future<void> _handle(BarcodeCapture c) async{
    if(scanned)return;
    final raw=c.barcodes.first.rawValue;
    if(raw==null||raw.isEmpty)return;
    scanned=true;
    final r=QrScannerService.scan(raw);
    await HistoryService.addHistory(
      HistoryItem(
        type:'QR',
        input:raw,
        riskScore:r.riskScore,
        riskLevel:r.riskLevel,
        fraudType:r.fraudType,
        dateTime:DateTime.now(),
      ),
    );
    if(!mounted)return;
    setState(()=>result=r);
    await controller.stop();
  }

  @override
  void dispose(){controller.dispose();super.dispose();}

  @override
  Widget build(BuildContext context){
    if(result!=null){
      return Scaffold(
        appBar:AppBar(title:const Text('QR Result')),
        body:Padding(
          padding:const EdgeInsets.all(16),
          child:Column(children:[
            RiskResultCard(
              riskScore:result!.riskScore,
              riskLevel:result!.riskLevel,
              fraudType:result!.fraudType,
              reasons:result!.reasons,
              advice:result!.advice,
            ),
            const SizedBox(height:16),
            ElevatedButton(
              onPressed:()async{
                scanned=false;
                setState(()=>result=null);
                await controller.start();
              },
              child:const Text('Scan Again'),
            )
          ]),
        ),
      );
    }
    return Scaffold(
      appBar:AppBar(
        title:const Text('QR Scanner'),
        actions:[
          IconButton(
            icon:Icon(flashOn?Icons.flash_on:Icons.flash_off),
            onPressed:()async{
              await controller.toggleTorch();
              setState(()=>flashOn=!flashOn);
            },
          ),
          IconButton(
            icon:const Icon(Icons.cameraswitch),
            onPressed:controller.switchCamera,
          )
        ],
      ),
      body:MobileScanner(
        controller:controller,
        onDetect:_handle,
      ),
    );
  }
}
