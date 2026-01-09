import 'package:flutter_test/flutter_test.dart';

import 'package:crypto_widget_app/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const CryptoWidgetApp());

    expect(find.text('Bitcoin Tracker'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);
  });
}
