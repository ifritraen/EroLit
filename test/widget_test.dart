import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:erolit/main.dart';

void main() {
  testWidgets('EroLit app shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EroLitApp(),
      ),
    );

    // Verify app title and tabs exist
    expect(find.text('EroLit'), findsOneWidget);
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Sources'), findsOneWidget);
    expect(find.text('Local'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
