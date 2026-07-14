import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/widgets/risk_result_card.dart';
import '../history/history_item.dart';
import '../history/history_service.dart';
import 'qr_result.dart';
import 'qr_scanner_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isProcessing = false;
  QrResult? result;

  Future<void> _handleCameraScan(BarcodeCapture capture) async {
    final rawValue = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .firstWhere(
          (value) => value != null && value.trim().isNotEmpty,
          orElse: () => null,
        );

    if (rawValue == null) {
      return;
    }

    await _processQrPayload(rawValue);
  }

  Future<void> _pickQrFromGallery() async {
    if (_isProcessing) {
      return;
    }

    await controller.stop();

    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        return;
      }

      final barcodeScanner = mlkit.BarcodeScanner(
        formats: [mlkit.BarcodeFormat.qrCode],
      );

      try {
        final barcodes = await barcodeScanner.processImage(
          mlkit.InputImage.fromFilePath(image.path),
        );

        final rawValue = barcodes
            .map((barcode) => barcode.rawValue)
            .firstWhere(
              (value) => value != null && value.trim().isNotEmpty,
              orElse: () => null,
            );

        if (rawValue == null) {
          if (mounted) {
            _showMessage('No QR code was found in this image.');
          }
          return;
        }

        await _processQrPayload(rawValue);
      } finally {
        await barcodeScanner.close();
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Unable to scan the selected image. Please try another.');
      }
    } finally {
      if (mounted && result == null && !_isProcessing) {
        await controller.start();
      }
    }
  }

  Future<void> _processQrPayload(String rawValue) async {
    final payload = rawValue.trim();

    if (payload.isEmpty || _isProcessing || result != null) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await controller.stop();

    try {
      final qrResult = QrScannerService.scan(payload);

      await HistoryService.addHistory(
        HistoryItem(
          type: 'QR',
          input: payload,
          riskScore: qrResult.riskScore,
          riskLevel: qrResult.riskLevel,
          fraudType: qrResult.fraudType,
          dateTime: DateTime.now(),
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        result = qrResult;
      });
    } catch (_) {
      if (mounted) {
        _showMessage('Unable to analyze this QR code. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _scanAgain() async {
    setState(() {
      result = null;
      _isProcessing = false;
    });

    await controller.start();
  }

  Future<void> _copyResult() async {
    final qrResult = result;
    if (qrResult == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: _formatResult(qrResult)));

    if (mounted) {
      _showMessage('QR scan result copied.');
    }
  }

  Future<void> _shareResult() async {
    final qrResult = result;
    if (qrResult == null) {
      return;
    }

    await Share.share(
      _formatResult(qrResult),
      subject: 'Vigil AI QR Scan Result',
    );
  }

  String _formatResult(QrResult qrResult) {
    final reasons = qrResult.reasons.map((reason) => '- $reason').join('\n');

    return '''
Vigil AI QR Scan Result

QR Content:
${qrResult.rawValue}

Risk Score: ${qrResult.riskScore}/100
Risk Level: ${qrResult.riskLevel}
Fraud Type: ${qrResult.fraudType}

Reasons:
$reasons

Advice:
${qrResult.advice}
''';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (result != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('QR Result')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'QR Content',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SelectableText(result!.rawValue),
                const SizedBox(height: 20),
                RiskResultCard(
                  riskScore: result!.riskScore,
                  riskLevel: result!.riskLevel,
                  fraudType: result!.fraudType,
                  reasons: result!.reasons,
                  advice: result!.advice,
                  onCopy: _copyResult,
                  onShare: _shareResult,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _scanAgain,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          IconButton(
            tooltip: 'Scan from gallery',
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: _isProcessing ? null : _pickQrFromGallery,
          ),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: controller,
            builder: (context, state, child) {
              final isTorchAvailable =
                  state.torchState != TorchState.unavailable;

              return IconButton(
                tooltip: 'Toggle flash',
                icon: Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                ),
                onPressed: _isProcessing || !isTorchAvailable
                    ? null
                    : controller.toggleTorch,
              );
            },
          ),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: controller,
            builder: (context, state, child) {
              final canSwitchCamera = (state.availableCameras ?? 0) > 1;

              return IconButton(
                tooltip: 'Switch camera',
                icon: const Icon(Icons.cameraswitch),
                onPressed: _isProcessing || !canSwitchCamera
                    ? null
                    : controller.switchCamera,
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _handleCameraScan,
            errorBuilder: (context, error, child) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Camera unavailable. Please allow camera permission and try again.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          if (_isProcessing)
            const ColoredBox(
              color: Color(0x99000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
