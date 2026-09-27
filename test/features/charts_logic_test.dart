import 'package:events_tracker/core/charts/series.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/investing/invest_charts.dart';
import 'package:events_tracker/features/investing/portfolio.dart';
import 'package:events_tracker/features/money/money_charts.dart';
import 'package:events_tracker/features/sleep/sleep_charts.dart';
import 'package:events_tracker/features/trackers/tracker_charts.dart';
import 'package:flutter_test/flutter_test.dart';

SleepSession sleep(int id, DateTime at, DateTime? wake) =>
    SleepSession(id: id, sleepAt: at, wakeAt: wake);

Expense exp(int cents, DateTime d, int cat) => Expense(
  id: cents + cat,
  amountCents: cents,
  categoryId: cat,
  date: d,
  paymentMethod: 'Card',
);

Category cat(int id, String name, {int? budget, bool archived = false}) =>
    Category(id: id, name: name, budgetCents: budget, archived: archived);

void main() {
  final today = DateTime(2026, 9, 27, 15);

  group('series helpers', () {
    test('lastDays is oldest first and ends today', () {
      final d = lastDays(3, today);
      expect(d, [
        DateTime(2026, 9, 25),
        DateTime(2026, 9, 26),
        DateTime(2026, 9, 27),
      ]);
    });

    test('lastDays crosses month and year ends', () {
      expect(lastDays(3, DateTime(2027, 1, 1)).first, DateTime(2026, 12, 30));
    });

    test('lastWeeks are Mondays, lastMonths are firsts', () {
      expect(lastWeeks(2, today), [
        DateTime(2026, 9, 14),
        DateTime(2026, 9, 21),
      ]);
      expect(lastMonths(3, DateTime(2026, 1, 15)), [
        DateTime(2025, 11),
        DateTime(2025, 12),
        DateTime(2026, 1),
      ]);
    });

    test('day labels: weekday for a week, sparse numbers for a month', () {
      expect(dayLabel(DateTime(2026, 9, 27), 7), 'Su');
      expect(dayLabel(DateTime(2026, 9, 27), 30), '');
      expect(dayLabel(DateTime(2026, 9, 25), 30), '25');
      expect(dayLabel(DateTime(2026, 9, 1), 30), '1');
    });
  });

  group('sleep charts', () {
    final days = lastDays(3, today);
    test('a night counts toward the wake day, across midnight; open ones are skipped', () {
      final h = sleepHoursPerDay([
        sleep(1, DateTime(2026, 9, 25, 23, 30), DateTime(2026, 9, 26, 7, 30)),
        sleep(2, DateTime(2026, 9, 26, 23), DateTime(2026, 9, 27, 6, 30)),
        sleep(3, DateTime(2026, 9, 27, 23), null),
        sleep(
          4,
          DateTime(2026, 9, 20, 23),
          DateTime(2026, 9, 21, 7),
        ), // outside
      ], days);
      expect(h, [0, 8, 7.5]);
    });

    test('bedtimes sort after-midnight ones after evening ones', () {
      final b = bedtimesIn([
        sleep(1, DateTime(2026, 9, 25, 23, 0), DateTime(2026, 9, 26, 7)),
        sleep(2, DateTime(2026, 9, 27, 0, 30), DateTime(2026, 9, 27, 7)),
      ], days);
      expect(b.map((x) => x.minutes), [1380, 1470]);
    });

    test('consistency: average and spread, null when empty', () {
      expect(bedtimeConsistency(const []), isNull);
      final c = bedtimeConsistency([1380, 1440])!;
      expect(c.average, 1410);
      expect(c.spread, 30);
      expect(bedtimeConsistency([1380, 1380])!.spread, 0);
    });

    test('clock text wraps past midnight', () {
      expect(clockOf(1380), '23:00');
      expect(clockOf(1470), '00:30');
      expect(clockOf(1412.4), '23:32');
    });
  });

  group('money charts', () {
    final cats = [
      cat(1, 'Food', budget: 50000),
      cat(2, 'Fun'),
      cat(3, 'Old', budget: 1000, archived: true),
    ];
    final expenses = [
      exp(10000, DateTime(2026, 9, 3), 1),
      exp(5000, DateTime(2026, 9, 20), 1),
      exp(2000, DateTime(2026, 9, 5), 2),
      exp(7000, DateTime(2026, 8, 12), 1),
    ];

    test('monthly totals per month, zero when empty', () {
      final t = monthlyTotals(expenses, lastMonths(3, today));
      expect(t, [0, 7000, 17000]);
    });

    test('category totals sorted, empty categories left out', () {
      final c = categoryTotals(expenses, today, cats);
      expect(c.map((x) => (x.name, x.spentCents)), [
        ('Food', 15000),
        ('Fun', 2000),
      ]);
    });

    test('budget vs actual lists only active budgeted categories', () {
      final b = budgetVsActual(expenses, today, cats);
      expect(b.map((x) => (x.name, x.spentCents, x.budgetCents)), [
        ('Food', 15000, 50000),
      ]);
      expect(budgetVsActual(const [], today, cats).single.spentCents, 0);
    });
  });

  group('tracker charts', () {
    final days = lastDays(3, today);
    TrackerEntry entry(DateTime day, {DateTime? start, DateTime? end}) =>
        TrackerEntry(
          id: day.day,
          trackerId: 1,
          day: day,
          startAt: start,
          endAt: end,
        );

    test('habit days and completion rate', () {
      final v = habitPerDay([
        entry(DateTime(2026, 9, 25)),
        entry(DateTime(2026, 9, 27)),
      ], days);
      expect(v, [1, 0, 1]);
      expect(completionRate(v), closeTo(2 / 3, 1e-9));
      expect(completionRate(const []), 0);
    });

    test(
      'minutes per day sums sessions and counts a running one up to now',
      () {
        final v = minutesPerDay(
          [
            entry(
              DateTime(2026, 9, 26),
              start: DateTime(2026, 9, 26, 20),
              end: DateTime(2026, 9, 26, 20, 30),
            ),
            entry(
              DateTime(2026, 9, 26),
              start: DateTime(2026, 9, 26, 22),
              end: DateTime(2026, 9, 26, 22, 15),
            ),
            entry(
              DateTime(2026, 9, 27),
              start: DateTime(2026, 9, 27, 14),
              end: null,
            ),
          ],
          days,
          today,
        );
        expect(v, [0, 45, 60]);
      },
    );
  });

  group('invest charts', () {
    final stock = Stock(
      id: 1,
      symbol: 'AAPL',
      name: 'Apple',
      lastPriceCents: 1500,
      priceDate: today,
    );
    Trade t(int id, bool buy, DateTime d, int qty, int price) => Trade(
      id: id,
      stockId: 1,
      isBuy: buy,
      date: d,
      quantity: qty,
      priceCents: price,
      feesCents: 0,
    );
    final trades = [
      t(1, true, DateTime(2026, 8, 3), 10, 1000),
      t(2, false, DateTime(2026, 9, 15), 4, 1500), // week of 14 Sep: +20.00
      t(3, false, DateTime(2026, 9, 24), 2, 900), // week of 21 Sep: -2.00
    ];
    final p = buildPortfolio([stock], trades, today);

    test('realized P/L lands in the week of the sale', () {
      final w = lastWeeks(3, today);
      expect(realizedPerWeek(p, w), [0, 2000, -200]);
    });

    test('allocation shares add up and sort biggest first', () {
      final a = allocation(p);
      expect(a.single.symbol, 'AAPL');
      expect(a.single.percent, 100);
      expect(a.single.valueCents, 4 * 1500);
    });

    test('snapshots outside the range are dropped, sorted oldest first', () {
      final snaps = [
        WeeklySnapshot(
          id: 1,
          weekStart: DateTime(2026, 9, 21),
          investedCents: 1,
          valueCents: 2,
        ),
        WeeklySnapshot(
          id: 2,
          weekStart: DateTime(2026, 1, 5),
          investedCents: 1,
          valueCents: 2,
        ),
        WeeklySnapshot(
          id: 3,
          weekStart: DateTime(2026, 9, 14),
          investedCents: 1,
          valueCents: 2,
        ),
      ];
      final r = snapshotsForWeeks(snaps, lastWeeks(3, today));
      expect(r.map((s) => s.id), [3, 1]);
    });
  });
}
