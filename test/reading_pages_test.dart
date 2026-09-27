import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/features/reading/reading_repository.dart';
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

Future<void> _open(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const TrackerApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 2)); // splash
}

Future<void> _teardown(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 100));
  await tester.runAsync(db.close);
}

void main() {
  testWidgets(
    'library lists books; timer runs, survives a restart, and stops with a page',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      await tester.runAsync(
        () => ReadingRepository(db).addBook(
          BooksCompanion.insert(
            title: 'Dune',
            author: const Value('Frank Herbert'),
            totalPages: const Value(400),
          ),
        ),
      );

      await _open(tester, db);
      await tester.tap(find.text('Read'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      expect(find.text('Dune'), findsOneWidget);
      expect(find.text('Want to read'), findsWidgets);

      await tester.tap(find.text('Dune'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      await tester.tap(find.text('Start reading'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      expect(find.text('Stop reading'), findsOneWidget);

      // "Close the app": tear the UI down, then reopen on the same database.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
      await _open(tester, db);
      await tester.tap(find.text('Read'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      await tester.tap(find.text('Dune'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      expect(find.text('Stop reading'), findsOneWidget); // timer still running

      await tester.tap(find.text('Stop reading'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.enterText(
        find.widgetWithText(TextField, 'Page you reached'),
        '100',
      );
      await tester.tap(find.text('Stop'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);

      expect(find.text('Start reading'), findsOneWidget);
      expect(find.textContaining('Page 100 of 400'), findsOneWidget);
      expect(find.textContaining('25%'), findsOneWidget);

      // Dashboard card shows a streak once a session exists.
      await tester.pageBack();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byTooltip('Home'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      await tester.scrollUntilVisible(
        find.textContaining('day streak'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.textContaining('day streak'), findsOneWidget);
      await _teardown(tester, db);
    },
  );
}
