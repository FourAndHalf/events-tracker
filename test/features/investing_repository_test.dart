import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/investing/investing_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late InvestingRepository repo;
  late int stock;

  TradesCompanion trade({
    required bool buy,
    required DateTime d,
    required int qty,
    int price = 1000,
  }) => TradesCompanion.insert(
    stockId: stock,
    isBuy: buy,
    date: d,
    quantity: qty,
    priceCents: price,
    feesCents: const Value(0),
  );

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = InvestingRepository(db);
    stock = await repo.addStock('aapl', 'Apple');
  });
  tearDown(() => db.close());

  test('symbol is stored upper-case and unique', () async {
    expect((await repo.watchStocks().first).single.symbol, 'AAPL');
    expect(() => repo.addStock('AAPL', 'Again'), throwsA(anything));
  });

  test('sale bigger than holding is rejected and nothing is saved', () async {
    await repo.addTrade(trade(buy: true, d: DateTime(2026, 1, 1), qty: 5));
    await expectLater(
      repo.addTrade(trade(buy: false, d: DateTime(2026, 1, 5), qty: 6)),
      throwsA(isA<OversellException>()),
    );
    expect((await repo.watchTrades().first).length, 1);
  });

  test('editing an old buy so a later sale is uncovered is rejected', () async {
    final buyId = await repo.addTrade(
      trade(buy: true, d: DateTime(2026, 1, 1), qty: 10),
    );
    await repo.addTrade(trade(buy: false, d: DateTime(2026, 1, 5), qty: 8));
    final buy = (await repo.watchTrades().first).firstWhere(
      (t) => t.id == buyId,
    );
    await expectLater(
      repo.updateTrade(buy.copyWith(quantity: 5)),
      throwsA(isA<OversellException>()),
    );
    await repo.updateTrade(buy.copyWith(quantity: 9)); // still covers 8
  });

  test('deleting a buy that a sale depends on is rejected; deleting the sale is fine', () async {
    final buyId = await repo.addTrade(
      trade(buy: true, d: DateTime(2026, 1, 1), qty: 10),
    );
    final sellId = await repo.addTrade(
      trade(buy: false, d: DateTime(2026, 1, 5), qty: 4),
    );
    final all = await repo.watchTrades().first;
    await expectLater(
      repo.deleteTrade(all.firstWhere((t) => t.id == buyId)),
      throwsA(isA<OversellException>()),
    );
    await repo.deleteTrade(all.firstWhere((t) => t.id == sellId));
    await repo.deleteTrade(all.firstWhere((t) => t.id == buyId));
    expect(await repo.watchTrades().first, isEmpty);
  });

  test('a backdated sale that lands before the buy is rejected', () async {
    await repo.addTrade(trade(buy: true, d: DateTime(2026, 2, 1), qty: 5));
    await expectLater(
      repo.addTrade(trade(buy: false, d: DateTime(2026, 1, 15), qty: 1)),
      throwsA(isA<OversellException>()),
    );
  });

  test('setPrice stores price and date', () async {
    await repo.setPrice(stock, 15025, DateTime(2026, 3, 1));
    final s = (await repo.watchStocks().first).single;
    expect(s.lastPriceCents, 15025);
    expect(s.priceDate, DateTime(2026, 3, 1));
  });
}
