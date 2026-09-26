import 'package:events_tracker/core/widgets/splash_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash shows the icon, then reveals the page', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplashOverlay(child: Text('home'))),
    );
    expect(find.byType(Image), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();
    expect(find.byType(Image), findsNothing);
    expect(find.text('home'), findsOneWidget);
  });
}
