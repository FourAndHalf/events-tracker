import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/money/money_format.dart';
import 'package:events_tracker/features/investing/portfolio.dart';
import 'package:flutter_test/flutter_test.dart';

Stock stock(int id, String sym, {int? price, DateTime? at}) =>
    Stock(id: id, symbol: sym, name: sym, lastPriceCents: price, priceDate: at);

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

void main() {
  final today = DateTime(2026, 6, 1);

  test('totals across stocks: invested, value, unrealized, realized', () {
    final p = buildPortfolio(
      [stock(1, 'AAA', price: 2000), stock(2, 'BBB', price: 500)],
      [
        trade(1, 1, true, DateTime(2026, 1, 1), 10, 1000),
        trade(2, 1, false, DateTime(2026, 2, 1), 4, 1500), // +2000 realized
        trade(3, 2, true, DateTime(2026, 3, 1), 20, 400),
      ],
      today,
    );
    expect(p.realizedCents, 2000);
    expect(p.investedCents, 6 * 1000 + 20 * 400);
    expect(p.valueCents, 6 * 2000 + 20 * 500);
    expect(p.unrealizedCents, (12000 + 10000) - (6000 + 8000));
    expect(p.unpricedCount, 0);
  });

  test('stock without a price counts at cost and is flagged', () {
    final p = buildPortfolio(
      [stock(1, 'AAA')],
      [trade(1, 1, true, DateTime(2026, 1, 1), 5, 1000)],
      today,
    );
    expect(p.valueCents, 5000);
    expect(p.unrealizedCents, 0);
    expect(p.unpricedCount, 1);
  });

  test(
    'closed positions are excluded from invested/value but keep realized P/L',
    () {
      final p = buildPortfolio(
        [stock(1, 'AAA', price: 900)],
        [
          trade(1, 1, true, DateTime(2026, 1, 1), 5, 1000),
          trade(2, 1, false, DateTime(2026, 2, 1), 5, 800),
        ],
        today,
      );
      expect(p.open, isEmpty);
      expect(p.investedCents, 0);
      expect(p.realizedCents, -1000);
    },
  );

  test('sale summary sums lots and reports the days-held range', () {
    final p = buildPortfolio(
      [stock(1, 'AAA')],
      [
        trade(1, 1, true, DateTime(2025, 1, 1), 1, 1000),
        trade(2, 1, true, DateTime(2026, 1, 20), 1, 1200),
        trade(3, 1, false, DateTime(2026, 2, 1), 2, 1500),
      ],
      today,
    );
    final s = p.sales[3]!;
    expect(s.profitCents, (1500 - 1000) + (1500 - 1200));
    expect(s.minDays, 12);
    expect(s.maxDays, 396);
    expect(s.allLongTerm, isFalse); // one lot is long-term, one short-term
    expect(s.isWin, isTrue);
  });

  test('price staleness', () {
    expect(isPriceStale(stock(1, 'A'), today), isTrue);
    expect(
      isPriceStale(stock(1, 'A', price: 1, at: DateTime(2026, 5, 31)), today),
      isFalse,
    );
    expect(
      isPriceStale(stock(1, 'A', price: 1, at: DateTime(2026, 5, 25)), today),
      isTrue,
    );
    expect(
      priceAgeDays(stock(1, 'A', price: 1, at: DateTime(2026, 5, 25)), today),
      7,
    );
  });

  test('parseCentsOrZero', () {
    expect(parseCentsOrZero(''), 0);
    expect(parseCentsOrZero('0'), 0);
    expect(parseCentsOrZero('0.00'), 0);
    expect(parseCentsOrZero('1.5'), 150);
    expect(parseCentsOrZero('-1'), isNull);
    expect(parseCentsOrZero('x'), isNull);
  });
}
