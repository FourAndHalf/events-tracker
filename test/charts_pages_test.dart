import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/router/app_router.dart';
import 'package:events_tracker/features/investing/investing_repository.dart';
import 'package:events_tracker/features/reading/reading_repository.dart';
import 'package:events_tracker/features/trackers/tracker_logic.dart';
import 'package:events_tracker/features/trackers/trackers_repository.dart';
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

Future<AppDatabase> _seed(WidgetTester tester) async {
  final db = AppDatabase(NativeDatabase.memory());
  final now = DateTime.now();
  await tester.runAsync(() async {
    final y = DateTime(now.year, now.month, now.day - 1);
    await db
        .into(db.sleepSessions)
        .insert(
          SleepSessionsCompanion.insert(
            sleepAt: DateTime(y.year, y.month, y.day - 0, 23),
            wakeAt: Value(DateTime(now.year, now.month, now.day, 7)),
          ),
        );
    await db
        .into(db.sleepSessions)
        .insert(
          SleepSessionsCompanion.insert(
            sleepAt: DateTime(y.year, y.month, y.day - 1, 23, 30),
            wakeAt: Value(DateTime(y.year, y.month, y.day, 6, 30)),
          ),
        );
    await (db.update(db.categories)..where((c) => c.id.equals(1))).write(
      const CategoriesCompanion(budgetCents: Value(50000)),
    );
    await db
        .into(db.expenses)
        .insert(
          ExpensesCompanion.insert(
            amountCents: 12000,
            categoryId: 1,
            date: DateTime(now.year, now.month, 1),
            paymentMethod: 'Card',
          ),
        );
    final r = ReadingRepository(db);
    final book = await r.addBook(BooksCompanion.insert(title: 'Dune'));
    final sid = await r.startSession(
      book,
      DateTime(now.year, now.month, now.day, 9),
    );
    await r.stopSession(
      sid,
      DateTime(now.year, now.month, now.day, 9, 40),
      endPage: 25,
    );
    final inv = InvestingRepository(db);
    final stock = await inv.addStock('AAPL', 'Apple');
    await inv.setPrice(stock, 1500, now);
    await inv.addTrade(
      TradesCompanion.insert(
        stockId: stock,
        isBuy: true,
        date: DateTime(now.year, now.month, now.day - 40),
        quantity: 10,
        priceCents: 1000,
      ),
    );
    final t = TrackersRepository(db);
    final h = await t.addTracker('Meditate', 'star', TrackerType.habit);
    await t.toggleHabit(h, now);
  });
  return db;
}

Future<void> _open(WidgetTester tester, AppDatabase db, String route) async {
  appRouter.go(route);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const TrackerApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 2));
  await _settle(tester);
  await _settle(tester);
}

void main() {
  testWidgets('chart pages render with data', (tester) async {
    final db = await _seed(tester);

    await _open(tester, db, '/sleep/charts');
    expect(find.text('Sleep charts'), findsOneWidget);
    expect(find.textContaining('over 2 nights'), findsOneWidget);
    await tester.tap(find.text('Month'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('over 2 nights'), findsOneWidget);

    appRouter.go('/read/charts');
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);
    expect(find.text('Reading charts'), findsOneWidget);
    expect(find.textContaining('40 min in the last 7 days'), findsOneWidget);
    expect(find.textContaining('25 pages in the last 7 days'), findsOneWidget);

    appRouter.go('/money/charts');
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);
    expect(find.text('Money charts'), findsOneWidget);
    expect(find.textContaining('Food'), findsWidgets);
    expect(find.textContaining(r'$120.00 of $500.00'), findsOneWidget);

    appRouter.go('/invest/charts');
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);
    expect(find.text('Investing charts'), findsOneWidget);
    expect(find.textContaining('appears once two weeks'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('AAPL'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('100.0%'), findsOneWidget);

    appRouter.go('/trackers/1');
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);
    expect(find.text('Days done'.toUpperCase()), findsOneWidget);
    expect(find.textContaining('of the last 30 days'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(db.close);
  });

  testWidgets('each module has a charts button', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => db.select(db.settings).get());
    for (final route in ['/sleep', '/money', '/invest', '/read']) {
      await _open(tester, db, route);
      expect(find.byTooltip('Charts'), findsOneWidget, reason: route);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.runAsync(db.close);
  });
}
