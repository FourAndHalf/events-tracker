import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/router/app_router.dart';
import 'package:events_tracker/features/memories/memories_repository.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 300)),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _openMemories(WidgetTester tester, AppDatabase db) async {
  appRouter.go('/'); // the router is global: start every test at home
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const TrackerApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 2)); // splash
  await _settle(tester);
  await tester.tap(find.byTooltip('Memories'));
  await tester.pump(const Duration(milliseconds: 300));
  await _settle(tester);
}

Future<void> _tapSave(WidgetTester tester) async {
  // A message left on screen would cover the button.
  tester
      .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger).first)
      .removeCurrentSnackBar();
  await tester.pump();
  await tester.scrollUntilVisible(
    find.text('Save'),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(find.text('Save'));
  await tester.pump();
  await tester.tap(find.text('Save'));
}

Future<void> _teardown(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 100));
  await tester.runAsync(db.close);
}

void main() {
  testWidgets(
    'shows coming up, occasions and the timeline with approximate dates',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final soon = DateTime.now().add(const Duration(days: 3));
      await tester.runAsync(() async {
        final repo = MemoriesRepository(db);
        await repo.addEvent(
          MemoryEventsCompanion.insert(
            title: 'Mum birthday',
            categoryId: 1,
            createdAt: DateTime.now(),
            kind: const Value('occasion'),
            year: Value(soon.year - 60),
            month: Value(soon.month),
            day: Value(soon.day),
          ),
        );
        await repo.addEvent(
          MemoryEventsCompanion.insert(
            title: 'Goa trip',
            categoryId: 4,
            createdAt: DateTime.now(),
            year: const Value(2019),
            month: const Value(3),
            day: const Value(14),
            place: const Value('Goa'),
          ),
        );
        await repo.addEvent(
          MemoryEventsCompanion.insert(
            title: 'Moved to the city',
            categoryId: 3,
            createdAt: DateTime.now(),
            precision: const Value('year'),
            year: const Value(2015),
          ),
        );
      });

      await _openMemories(tester, db);
      expect(find.text('Coming up'.toUpperCase()), findsOneWidget);
      expect(find.text('in 3 days'), findsWidgets);
      expect(find.textContaining('60th birthday'), findsOneWidget);
      expect(find.text('March 2019'), findsOneWidget);
      expect(find.textContaining('14 Mar 2019'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Sometime in 2015'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Sometime in 2015'), findsOneWidget);
      await _teardown(tester, db);
    },
  );

  testWidgets('add form saves a one-time event with a month-only date', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(
      () => db.select(db.memoryEvents).get(),
    ); // open + seed
    await _openMemories(tester, db);
    await tester.tap(find.text('Add'));
    await tester.pump(const Duration(milliseconds: 300));

    // Saving without a title is refused.
    await _tapSave(tester);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Enter a title'), findsOneWidget);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byType(TextField).first, 'Grandpa visit');
    await tester.tap(find.text('Month and year'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.widgetWithText(TextField, 'Year'), '2021');
    await _tapSave(tester);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Choose a month'), findsOneWidget);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('July').last);
    await tester.pump(const Duration(milliseconds: 300));
    await _tapSave(tester);
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);

    final saved = await tester.runAsync(
      () => db.select(db.memoryEvents).getSingle(),
    );
    expect(saved!.title, 'Grandpa visit');
    expect(
      (saved.precision, saved.year, saved.month, saved.day),
      ('month', 2021, 7, null),
    );
    expect(find.text('July 2021'), findsOneWidget); // back on the timeline
    await _teardown(tester, db);
  });
}
