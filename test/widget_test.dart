import 'package:flutter_test/flutter_test.dart';
import 'package:vigil_ai/main.dart';

void main() {
  testWidgets('Vigil AI opens the dashboard', (tester) async {
    await tester.pumpWidget(const VigilAIApp());

    expect(find.text('Vigil AI'), findsOneWidget);
    expect(find.text('SMS Scam'), findsOneWidget);
    expect(find.text('QR Scanner'), findsOneWidget);
  });
}
