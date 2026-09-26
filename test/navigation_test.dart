import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home header, settings icon, tabs and home icon', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const TrackerApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 2)); // let the splash finish
    await tester.pump();

    // Home: app name in header, settings icon, only Sleep and Money tabs.
    expect(find.text('Events'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Sleep goal'.toUpperCase()), findsOneWidget);
    await tester.pageBack();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Money'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byTooltip('Home'), findsOneWidget);

    await tester.tap(find.byTooltip('Home'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Events'), findsOneWidget);

    // Unmount so provider streams close, then close the database for real.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(db.close);
  });
}
