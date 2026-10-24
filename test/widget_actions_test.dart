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
  testWidgets('widget "sleep" button starts a session, never wakes one', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => db.select(db.settings).get());
    final ref = await _boot(tester, db);

    for (var i = 0; i < 2; i++) {
      await tester.runAsync(() => runWidgetAction(WidgetAction.addSleep, ref));
      await _settle(tester);
    }
    final rows = await tester.runAsync(() => db.select(db.sleepSessions).get());
    expect(rows!.single.wakeAt, isNull);

    await _close(tester, db);
  });

  testWidgets('widget "read" button resumes the last book, never stops it', (
    tester,
  ) async {
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

    for (var i = 0; i < 2; i++) {
      await tester.runAsync(() => runWidgetAction(WidgetAction.addRead, ref));
      await _settle(tester);
    }
    final running = await tester.runAsync(
      () => ReadingRepository(db).runningSession(),
    );
    expect(running?.bookId, bookId);

    await _close(tester, db);
  });
}
