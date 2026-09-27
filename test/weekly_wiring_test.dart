import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/notifications/report_notifier.dart';
import 'package:events_tracker/features/investing/investing_repository.dart';
import 'package:events_tracker/features/investing/weekly_report.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotifier implements ReportNotifier {
  final scheduled = <(DateTime, String, String)>[];
  int cancels = 0;
  @override
  Future<void> schedule(DateTime when, String title, String body) async =>
      scheduled.add((when, title, body));
  @override
  Future<void> cancel() async => cancels++;
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required String route,
  }) async {}
  @override
  Future<void> cancelRange(int from, int to) async {}
}

Future<AppDatabase> _seed(WidgetTester tester) async {
  final db = AppDatabase(NativeDatabase.memory());
  await tester.runAsync(() async {
    final repo = InvestingRepository(db);
    final id = await repo.addStock('AAPL', 'Apple');
    final now = DateTime.now();
    await repo.addTrade(
      TradesCompanion.insert(
        stockId: id,
        isBuy: true,
        date: now.subtract(const Duration(days: 40)),
        quantity: 10,
        priceCents: 1000,
      ),
    );
    await repo.addTrade(
      TradesCompanion.insert(
        stockId: id,
        isBuy: false,
        date: now,
        quantity: 4,
        priceCents: 1500,
      ),
    );
    await repo.setPrice(id, 1200, now);
  });
  return db;
}

Future<void> _boot(WidgetTester tester, AppDatabase db, FakeNotifier n) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        reportNotifierProvider.overrideWithValue(n),
      ],
      child: const TrackerApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 2)); // splash
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _teardown(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 100));
  await tester.runAsync(db.close);
}

void main() {
  testWidgets(
    'snapshot is saved and the Sunday notification is scheduled with headline numbers',
    (tester) async {
      final db = await _seed(tester);
      final n = FakeNotifier();
      await _boot(tester, db, n);

      final snaps = await tester.runAsync(
        () => db.select(db.weeklySnapshots).get(),
      );
      expect(snaps!.length, 1);
      expect(snaps.single.weekStart, weekStartOf(DateTime.now()));
      expect(snaps.single.valueCents, 6 * 1200); // 6 shares left at 12.00
      expect(snaps.single.investedCents, 6 * 1000);

      expect(n.scheduled, isNotEmpty);
      final (at, title, body) = n.scheduled.last;
      expect(at.weekday, DateTime.sunday);
      expect(at.hour, 19); // default 19:00
      expect(at.isAfter(DateTime.now()), isTrue);
      expect(title, 'Your investing week');
      expect(body, contains('1 trade ')); // only the sale is in this week
      expect(body, contains(r'Realized +$20.00')); // 4 x (15.00 - 10.00)
      expect(body, contains(r'Portfolio $72.00'));
      await _teardown(tester, db);
    },
  );

  testWidgets(
    'dashboard investing card and weekly report page show the numbers',
    (tester) async {
      final db = await _seed(tester);
      await _boot(tester, db, FakeNotifier());

      // Dashboard card
      expect(find.text('INVESTING'), findsOneWidget);
      expect(find.text(r'$72.00'), findsWidgets);
      expect(
        find.textContaining(r'+$20.00', findRichText: true),
        findsWidgets,
      ); // this week's realized
      expect(
        find.textContaining(r'+$12.00', findRichText: true),
        findsWidgets,
      ); // unrealized

      // Weekly report page via the Invest tab
      await tester.tap(find.text('Invest'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byTooltip('Weekly report'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Weekly report'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Win rate'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Win rate'), findsOneWidget);
      expect(find.text('100% (1 of 1)'), findsOneWidget);
      expect(find.text('Average holding time'), findsOneWidget);
      expect(find.text('40 days'), findsOneWidget);
      await _teardown(tester, db);
    },
  );

  testWidgets('turning the weekly report off cancels the notification', (
    tester,
  ) async {
    final db = await _seed(tester);
    final n = FakeNotifier();
    await _boot(tester, db, n);
    await tester.runAsync(
      () => (db.update(db.settings))
          .write(const SettingsCompanion(weeklyReportEnabled: Value(false))),
    );
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(n.cancels, greaterThan(0));
    await _teardown(tester, db);
  });
}
