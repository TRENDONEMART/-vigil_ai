import 'package:flutter_test/flutter_test.dart';
import 'package:vigil_ai/features/apk_scanner/apk_scanner_service.dart';

void main() {
  test('flags dangerous APK permissions', () {
    final result = ApkScannerService.scan(
      'Package: com.example.app\nPermissions: READ_SMS, REQUEST_INSTALL_PACKAGES',
    );

    expect(result.suspiciousIndicators, hasLength(2));
    expect(result.riskScore, greaterThan(0));
  });

  test('flags modified APK descriptions', () {
    final result = ApkScannerService.scan(
      'Premium unlocked mod APK from unknown source',
    );

    expect(result.fraudType, 'Suspicious APK');
    expect(result.suspiciousIndicators, isNotEmpty);
  });
}
