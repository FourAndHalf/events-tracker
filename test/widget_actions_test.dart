import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/router/app_router.dart';
import 'package:events_tracker/features/reading/reading_repository.dart';
import 'package:events_tracker/features/widget/widget_bridge.dart';
import 'package:events_tracker/features/widget/widget_logic.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

Future<WidgetRef> _boot(WidgetTester tester, AppDatabase db) async {
  appRouter.go('/');
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const TrackerApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 2));
  await _settle(tester);
  return tester.element(find.byType(WidgetLinks)) as WidgetRef;
}

Future<void> _close(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 100));
  await tester.runAsync(db.close);
}

void main() {
  testWidgets(
    'widget "sleep" button starts sleep, then wakes with the quality prompt',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      await tester.runAsync(() => db.select(db.settings).get());
      final ref = await _boot(tester, db);

      await tester.runAsync(
        () => runWidgetAction(WidgetAction.sleepToggle, ref),
      );
      await _settle(tester);
      var rows = await tester.runAsync(() => db.select(db.sleepSessions).get());
      expect(rows!.single.wakeAt, isNull);

      unawaited(runWidgetAction(WidgetAction.sleepToggle, ref));
      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 400)),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('How did you sleep?'), findsOneWidget);
      rows = await tester.runAsync(() => db.select(db.sleepSessions).get());
      expect(rows!.single.wakeAt, isNotNull);
      await tester.tap(find.text('Skip'));
      await tester.pump(const Duration(milliseconds: 300));

      await _close(tester, db);
    },
  );

  testWidgets('widget "expense" button opens the add-expense form', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => db.select(db.settings).get());
    final ref = await _boot(tester, db);
    await tester.runAsync(() => runWidgetAction(WidgetAction.addExpense, ref));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Add expense'), findsWidgets);
    await _close(tester, db);
  });

  testWidgets(
    'widget "read" button resumes the last book, then offers to stop',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      late int bookId;
      await tester.runAsync(() async {
        final repo = ReadingRepository(db);
        bookId = await repo.addBook(
          BooksCompanion.insert(title: 'Dune', status: const Value('reading')),
        );
        final s = await repo.startSession(
          bookId,
          DateTime.now().subtract(const Duration(days: 1)),
        );
        await repo.stopSession(
          s,
          DateTime.now().subtract(const Duration(days: 1, hours: -1)),
          endPage: 10,
        );
      });
      final ref = await _boot(tester, db);

      await tester.runAsync(
        () => runWidgetAction(WidgetAction.readToggle, ref),
      );
      await _settle(tester);
      final running = await tester.runAsync(
        () => ReadingRepository(db).runningSession(),
      );
      expect(running?.bookId, bookId);

      unawaited(runWidgetAction(WidgetAction.readToggle, ref));
      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 900)),
      );
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Stop reading'), findsWidgets);
      await tester.tap(find.text('Keep reading'));
      await tester.pump(const Duration(milliseconds: 300));

      await _close(tester, db);
    },
  );
}
