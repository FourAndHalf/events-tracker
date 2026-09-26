import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/investing/investing_repository.dart';
import 'package:events_tracker/features/investing/weekly_report.dart';
import 'package:flutter_test/flutter_test.dart';

Stock stock(int id, String sym) => Stock(id: id, symbol: sym, name: sym);
Trade trade(
  int id,
  int stockId,
  bool buy,
  DateTime d,
  int qty,
  int price, {
  int fees = 0,
}) => Trade(
  id: id,
  stockId: stockId,
  isBuy: buy,
  date: d,
  quantity: qty,
  priceCents: price,
  feesCents: fees,
);
WeeklySnapshot snap(DateTime week, int value) =>
    WeeklySnapshot(id: 0, weekStart: week, investedCents: 0, valueCents: value);

void main() {
  // Monday 2 Mar 2026 .. Sunday 8 Mar 2026
  final mon = DateTime(2026, 3, 2);
  final sun = DateTime(2026, 3, 8);
  final today = DateTime(2026, 3, 6);

  group('week boundaries', () {
    test('weekStartOf gives Monday for any day', () {
      for (var d = 2; d <= 8; d++) {
        expect(weekStartOf(DateTime(2026, 3, d, 15, 30)), mon);
      }
      expect(weekStartOf(DateTime(2026, 3, 9)), DateTime(2026, 3, 9));
    });

    test('week crossing a month/year boundary', () {
      expect(weekStartOf(DateTime(2026, 1, 1)), DateTime(2025, 12, 29));
      expect(weekEndOf(DateTime(2025, 12, 29)), DateTime(2026, 1, 5));
    });

    test('trades on Sunday count, trades on the next Monday do not', () {
      final r = buildWeeklyReport(
        weekStart: mon,
        stocks: [stock(1, 'A')],
        trades: [
          trade(1, 1, true, mon, 1, 100),
          trade(2, 1, true, sun.add(const Duration(hours: 23)), 1, 100),
          trade(3, 1, true, DateTime(2026, 3, 9), 1, 100),
          trade(4, 1, true, DateTime(2026, 3, 1), 1, 100), // Sunday before
        ],
        snapshots: const [],
        today: today,
        liveValueCents: 0,
      );
      expect(r.buyCount, 2);
    });
  });

  group('report numbers', () {
    final trades = [
      trade(
        1,
        1,
        true,
        DateTime(2026, 1, 5),
        10,
        1000,
        fees: 100,
      ), // earlier buy
      trade(2, 2, true, DateTime(2026, 3, 2), 5, 2000), // this week: buy 10,000
      trade(
        3,
        1,
        false,
        DateTime(2026, 3, 3),
        4,
        1500,
        fees: 40,
      ), // sell: 6,000 - 40
      trade(4, 1, false, DateTime(2026, 3, 5), 2, 800), // sell at a loss
      trade(5, 2, false, DateTime(2026, 3, 6), 5, 2400), // sell, win +2,000
    ];
    final stocks = [stock(1, 'AAA'), stock(2, 'BBB')];
    final r = buildWeeklyReport(
      weekStart: mon,
      stocks: stocks,
      trades: trades,
      snapshots: const [],
      today: today,
      liveValueCents: 50000,
    );

    test('counts and money in / out', () {
      expect(r.buyCount, 1);
      expect(r.sellCount, 3);
      expect(r.boughtCents, 10000);
      expect(r.soldCents, (6000 - 40) + 1600 + 12000);
    });

    test('realized P/L for the week and year', () {
      // AAA lot: 10 @1000 + 100 fee. Sale 3: 4 sh: cost 4000+40, proceeds 6000-40 => +1920
      // Sale 4: 2 sh: cost 2000+20, proceeds 1600 => -420. BBB: +2000.
      expect(r.realizedCents, 1920 - 420 + 2000);
      expect(r.yearRealizedCents, r.realizedCents);
    });

    test('win rate, best and worst', () {
      expect(r.closedCount, 3);
      expect(r.wins, 2);
      expect(r.winRatePercent, closeTo(66.67, 0.01));
      expect(r.best!.symbol, 'BBB');
      expect(r.best!.profitCents, 2000);
      expect(r.worst!.symbol, 'AAA');
      expect(r.worst!.profitCents, -420);
    });

    test('average holding time is weighted by shares', () {
      // AAA: 6 shares held 57 days (5 Jan -> 3 Mar = 57, 5 Mar = 59 for 2 shares); BBB: 5 shares, 4 days.
      final aaa3 = DateTime(2026, 3, 3).difference(DateTime(2026, 1, 5)).inDays;
      final aaa4 = DateTime(2026, 3, 5).difference(DateTime(2026, 1, 5)).inDays;
      expect(r.avgHoldDays, closeTo((aaa3 * 4 + aaa4 * 2 + 4 * 5) / 11, 0.001));
    });

    test('empty week has no win rate or averages', () {
      final e = buildWeeklyReport(
        weekStart: DateTime(2026, 2, 16),
        stocks: stocks,
        trades: trades,
        snapshots: const [],
        today: today,
        liveValueCents: 0,
      );
      expect(e.tradeCount, 0);
      expect(e.winRatePercent, isNull);
      expect(e.avgHoldDays, isNull);
      expect(e.best, isNull);
    });
  });

  test('year running total spans earlier weeks but not earlier years', () {
    final r = buildWeeklyReport(
      weekStart: mon,
      stocks: [stock(1, 'A')],
      trades: [
        trade(1, 1, true, DateTime(2025, 6, 1), 3, 1000),
        trade(2, 1, false, DateTime(2025, 12, 20), 1, 2000), // +1000 last year
        trade(
          3,
          1,
          false,
          DateTime(2026, 1, 20),
          1,
          1500,
        ), // +500 earlier this year
        trade(4, 1, false, DateTime(2026, 3, 3), 1, 1200), // +200 this week
        trade(
          5,
          1,
          false,
          DateTime(2026, 3, 12),
          0 + 1,
          9000,
        ), // future week, ignored
      ],
      snapshots: const [],
      today: today,
      liveValueCents: 0,
    );
    expect(r.realizedCents, 200);
    expect(r.yearRealizedCents, 700);
  });

  group('week-on-week value change', () {
    test(
      'current week uses the live value against the last earlier snapshot',
      () {
        final r = buildWeeklyReport(
          weekStart: mon,
          stocks: const [],
          trades: const [],
          snapshots: [
            snap(DateTime(2026, 2, 23), 90000),
            snap(DateTime(2026, 2, 16), 50000),
          ],
          today: today,
          liveValueCents: 95000,
        );
        expect(r.valueCents, 95000);
        expect(r.valueChangeCents, 5000);
      },
    );

    test('past week compares its snapshot with the one before', () {
      final r = buildWeeklyReport(
        weekStart: DateTime(2026, 2, 23),
        stocks: const [],
        trades: const [],
        snapshots: [
          snap(mon, 95000),
          snap(DateTime(2026, 2, 23), 90000),
          snap(DateTime(2026, 2, 9), 80000),
        ],
        today: today,
        liveValueCents: 95000,
      );
      expect(r.valueCents, 90000);
      expect(r.valueChangeCents, 10000); // skips the missing week, uses 9 Feb
    });

    test('no earlier snapshot means no change figure', () {
      final r = buildWeeklyReport(
        weekStart: mon,
        stocks: const [],
        trades: const [],
        snapshots: const [],
        today: today,
        liveValueCents: 1000,
      );
      expect(r.valueChangeCents, isNull);
    });

    test('past week without a snapshot has unknown value', () {
      final r = buildWeeklyReport(
        weekStart: DateTime(2026, 2, 16),
        stocks: const [],
        trades: const [],
        snapshots: const [],
        today: today,
        liveValueCents: 1000,
      );
      expect(r.valueCents, isNull);
    });
  });

  test('reportWeeks lists trade and snapshot weeks plus the current one, newest first', () {
    final w = reportWeeks(
      [
        trade(1, 1, true, DateTime(2026, 2, 11), 1, 1),
        trade(2, 1, true, DateTime(2026, 2, 12), 1, 1),
      ],
      [snap(DateTime(2026, 2, 23), 1)],
      today,
    );
    expect(w, [mon, DateTime(2026, 2, 23), DateTime(2026, 2, 9)]);
  });

  group('nextReportTime (Sunday 19:00 = 1140)', () {
    test('midweek goes to the coming Sunday', () {
      expect(
        nextReportTime(DateTime(2026, 3, 4, 10), 1140),
        DateTime(2026, 3, 8, 19),
      );
    });
    test('Sunday before the time is today', () {
      expect(
        nextReportTime(DateTime(2026, 3, 8, 12), 1140),
        DateTime(2026, 3, 8, 19),
      );
    });
    test('Sunday after the time is next week', () {
      expect(
        nextReportTime(DateTime(2026, 3, 8, 20), 1140),
        DateTime(2026, 3, 15, 19),
      );
    });
    test('Monday goes six days ahead', () {
      expect(
        nextReportTime(DateTime(2026, 3, 2, 8), 1140),
        DateTime(2026, 3, 8, 19),
      );
    });
  });

  test('weeklyHeadline', () {
    final r = buildWeeklyReport(
      weekStart: mon,
      stocks: [stock(1, 'A')],
      trades: [
        trade(1, 1, true, DateTime(2026, 3, 2), 1, 1000),
        trade(2, 1, false, DateTime(2026, 3, 3), 1, 1500),
      ],
      snapshots: [snap(DateTime(2026, 2, 23), 10000)],
      today: today,
      liveValueCents: 12000,
    );
    expect(
      weeklyHeadline(r, r'$'),
      r'2 trades · Realized +$5.00 · Portfolio $120.00 · (+$20.00 vs last week)',
    );
  });

  test('upsertSnapshot keeps one row per week and updates it', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = InvestingRepository(db);
    await repo.upsertSnapshot(mon, 100, 110);
    await repo.upsertSnapshot(mon, 100, 130);
    await repo.upsertSnapshot(DateTime(2026, 3, 9), 200, 210);
    final all = await repo.watchSnapshots().first;
    expect(all.length, 2);
    expect(all.firstWhere((s) => s.weekStart == mon).valueCents, 130);
  });
}
