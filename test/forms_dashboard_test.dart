import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/router/app_router.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _boot(WidgetTester tester, AppDatabase db, String route) async {
  appRouter.go(route);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const TrackerApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 2));
  await _settle(tester);
}

Future<void> _close(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 100));
  await tester.runAsync(db.close);
}

Future<void> _tapVisible(WidgetTester tester, Finder f) async {
  // A message left on screen would cover the button.
  tester
      .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger).first)
      .removeCurrentSnackBar();
  await tester.pump();
  await tester.scrollUntilVisible(
    f,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
}

void main() {
  testWidgets(
    'expense form validates, saves cents, and warns when over budget',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      await tester.runAsync(
        () => (db.update(db.categories)..where((c) => c.id.equals(1))).write(
          const CategoriesCompanion(budgetCents: Value(1000)),
        ),
      );
      await _boot(tester, db, '/money/add');

      await _tapVisible(tester, find.text('Save'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.textContaining('Enter an amount'), findsOneWidget);

      await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.enterText(find.byType(TextField).first, '12.50');
      await _tapVisible(tester, find.text('Save'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Choose a category'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Food'),
        -200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.widgetWithText(ChoiceChip, 'Food'));
      await tester.pump(const Duration(milliseconds: 300));
      await _tapVisible(tester, find.text('Save'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);

      final saved = await tester.runAsync(() => db.select(db.expenses).get());
      expect(saved!.single.amountCents, 1250); // integer cents, not 12.5
      expect(saved.single.categoryId, 1);
      await _settle(tester);
      expect(find.textContaining('over budget'), findsOneWidget);
      await _close(tester, db);
    },
  );

  testWidgets(
    'dashboard sleep button starts the night, then wakes with a prompt',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      await tester.runAsync(() => db.select(db.settings).get());
      await _boot(tester, db, '/');
      expect(
        find.text(DateFormat('EEEE d MMMM').format(DateTime.now())),
        findsOneWidget,
      );

      await tester.tap(find.text('Going to sleep'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      expect(find.text("I'm awake"), findsOneWidget);
      expect(find.text('Sleeping'.toUpperCase()), findsOneWidget);

      await tester.tap(find.text("I'm awake"));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      expect(find.text('How did you sleep?'), findsOneWidget);
      await tester.tap(find.text('Skip'));
      await tester.pump(const Duration(milliseconds: 300));
      final rows = await tester.runAsync(
        () => db.select(db.sleepSessions).get(),
      );
      expect(rows!.single.wakeAt, isNotNull);
      await _close(tester, db);
    },
  );

  testWidgets('a fresh dashboard shows every card with a first-run prompt', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => db.select(db.settings).get());
    await _boot(tester, db, '/');
    for (final t in [
      'Trackers: add a habit or a timer',
      'Reading: add your first book',
      'Investing: record your first trade',
      'Memories: add a birthday or a moment to remember',
    ]) {
      await tester.scrollUntilVisible(
        find.text(t),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(t), findsOneWidget);
    }
    await _close(tester, db);
  });
}
