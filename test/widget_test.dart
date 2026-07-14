import 'package:flutter_test/flutter_test.dart';
import 'package:vigil_ai/main.dart';

void main() {
  testWidgets('App starts successfully', (tester) async {
    await tester.pumpWidget(const VigilAIApp());
    await tester.pumpAndSettle();

    expect(find.byType(VigilAIApp), findsOneWidget);
  });
}