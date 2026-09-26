import 'package:events_tracker/features/investing/fifo.dart';
import 'package:events_tracker/features/investing/position.dart';
import 'package:flutter_test/flutter_test.dart';

int _id = 0;
TradeRecord buy(DateTime d, int qty, int price, {int fees = 0, int? id}) =>
    TradeRecord(
      id: id ?? ++_id,
      stockId: 1,
      isBuy: true,
      date: d,
      quantity: qty,
      priceCents: price,
      feesCents: fees,
    );
TradeRecord sell(DateTime d, int qty, int price, {int fees = 0, int? id}) =>
    TradeRecord(
      id: id ?? ++_id,
      stockId: 1,
      isBuy: false,
      date: d,
      quantity: qty,
      priceCents: price,
      feesCents: fees,
    );

void main() {
  final jan = DateTime(2026, 1, 10),
      feb = DateTime(2026, 2, 10),
      mar = DateTime(2026, 3, 10);

  group('FIFO matching', () {
    test(
      'sale uses the oldest lot first, across several buys and partial sells',
      () {
        final r = computeFifo([
          buy(jan, 10, 1000, id: 1),
          buy(feb, 10, 2000, id: 2),
          sell(mar, 15, 3000, id: 3),
          sell(mar, 3, 4000, id: 4),
        ]);
        expect(r.isValid, isTrue);
        // Sale 3: 10 from lot 1, 5 from lot 2. Sale 4: 3 from lot 2.
        expect(
          r.matches
              .map((m) => (m.sellTradeId, m.buyTradeId, m.quantity))
              .toList(),
          [(3, 1, 10), (3, 2, 5), (4, 2, 3)],
        );
        expect(r.openLots.single.buyTradeId, 2);
        expect(r.openLots.single.quantity, 2);
        expect(r.openLots.single.costCents, 2 * 2000);
      },
    );

    test('same-day buy counts before a sell', () {
      final r = computeFifo([
        sell(jan, 5, 1100, id: 2),
        buy(jan, 5, 1000, id: 1),
      ]);
      expect(r.isValid, isTrue);
      expect(r.heldQuantity, 0);
    });

    test('order of the input list does not matter', () {
      final a = [buy(jan, 4, 100, id: 1), sell(feb, 4, 150, id: 2)];
      expect(
        computeFifo(a.reversed).realizedCents,
        computeFifo(a).realizedCents,
      );
    });
  });

  group('realized P/L with fees', () {
    test('proceeds - sale fees - (cost + buy fees)', () {
      final r = computeFifo([
        buy(jan, 10, 1000, fees: 100, id: 1), // cost 10,000 + 100
        sell(feb, 10, 1500, fees: 200, id: 2), // proceeds 15,000 - 200
      ]);
      final m = r.matches.single;
      expect(m.costCents, 10100);
      expect(m.proceedsCents, 14800);
      expect(m.profitCents, 4700);
      expect(r.realizedCents, 4700);
    });

    test('fees are split across partial lots and always add up exactly', () {
      final r = computeFifo([
        buy(jan, 3, 1000, fees: 100, id: 1),
        sell(feb, 1, 1000, fees: 50, id: 2),
        sell(feb, 1, 1000, fees: 50, id: 3),
        sell(mar, 1, 1000, fees: 50, id: 4),
      ]);
      // All 3 shares sold: buy fees 100 fully consumed, sale fees 150 fully used.
      expect(r.matches.fold<int>(0, (a, m) => a + m.costCents), 3 * 1000 + 100);
      expect(
        r.matches.fold<int>(0, (a, m) => a + m.proceedsCents),
        3 * 1000 - 150,
      );
      expect(r.heldQuantity, 0);
      expect(r.heldCostCents, 0);
    });

    test('a sale spanning two lots splits its own fee by quantity', () {
      final r = computeFifo([
        buy(jan, 2, 1000, id: 1),
        buy(feb, 2, 1000, id: 2),
        sell(mar, 4, 1000, fees: 101, id: 3),
      ]);
      expect(r.matches.fold<int>(0, (a, m) => a + m.proceedsCents), 4000 - 101);
    });

    test('a loss is negative', () {
      final r = computeFifo([
        buy(jan, 1, 5000, id: 1),
        sell(feb, 1, 4000, id: 2),
      ]);
      expect(r.realizedCents, -1000);
    });
  });

  group('holding time', () {
    test('days held per matched lot', () {
      final r = computeFifo([
        buy(DateTime(2026, 1, 1), 1, 100, id: 1),
        buy(DateTime(2026, 1, 21), 1, 100, id: 2),
        sell(DateTime(2026, 2, 1), 2, 100, id: 3),
      ]);
      expect(r.matches.map((m) => m.daysHeld).toList(), [31, 11]);
    });

    test('under 1 year is short-term, exactly 1 year is long-term', () {
      LotMatch m(DateTime sellDate) => computeFifo([
        buy(DateTime(2025, 3, 10), 1, 100, id: 1),
        sell(sellDate, 1, 100, id: 2),
      ]).matches.single;
      expect(m(DateTime(2026, 3, 9)).isLongTerm, isFalse);
      expect(m(DateTime(2026, 3, 10)).isLongTerm, isTrue);
      expect(m(DateTime(2026, 9, 1)).isLongTerm, isTrue);
    });

    test('leap day: bought 29 Feb 2024, 28 Feb 2025 is still short-term', () {
      final r = computeFifo([
        buy(DateTime(2024, 2, 29), 1, 100, id: 1),
        sell(DateTime(2025, 2, 28), 1, 100, id: 2),
      ]);
      expect(r.matches.single.isLongTerm, isFalse);
    });
  });

  group('unrealized P/L', () {
    test('(last price - average cost) x quantity, buy fees included', () {
      final r = computeFifo([
        buy(jan, 10, 1000, fees: 100, id: 1),
        buy(feb, 10, 2000, id: 2),
        sell(mar, 5, 3000, id: 3), // uses 5 of lot 1
      ]);
      final p = positionFrom(r, 2500, DateTime(2026, 4, 10));
      expect(p.quantity, 15);
      // Remaining cost: 5*1000 + 50 fee left + 10*2000
      expect(p.costCents, 5000 + 50 + 20000);
      expect(p.valueCents, 15 * 2500);
      expect(p.unrealizedCents, 37500 - 25050);
      expect(p.oldestDays, 90);
    });

    test('no price set gives null value', () {
      final p = positionFrom(computeFifo([buy(jan, 1, 100, id: 1)]), null, feb);
      expect(p.valueCents, isNull);
      expect(p.unrealizedCents, isNull);
    });

    test('closed position is not open', () {
      final r = computeFifo([
        buy(jan, 1, 100, id: 1),
        sell(feb, 1, 100, id: 2),
      ]);
      expect(positionFrom(r, 100, mar).isOpen, isFalse);
    });
  });

  group('oversell guard', () {
    test('selling more than held is flagged', () {
      final r = computeFifo([
        buy(jan, 5, 100, id: 1),
        sell(feb, 6, 100, id: 2),
      ]);
      expect(r.isValid, isFalse);
      expect(r.oversoldTradeId, 2);
    });

    test('selling before buying is flagged', () {
      final r = computeFifo([
        sell(jan, 1, 100, id: 1),
        buy(feb, 1, 100, id: 2),
      ]);
      expect(r.oversoldTradeId, 1);
    });

    test('selling exactly what is held is fine', () {
      expect(
        computeFifo([buy(jan, 5, 100, id: 1), sell(feb, 5, 100, id: 2)])
            .isValid,
        isTrue,
      );
    });
  });
}
