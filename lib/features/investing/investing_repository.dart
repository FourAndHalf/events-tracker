import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import 'fifo.dart';

/// Thrown when a change would leave a sale bigger than the shares held.
class OversellException implements Exception {
  const OversellException();
  @override
  String toString() => 'Not enough shares held for that sale';
}

TradeRecord toRecord(Trade t) => TradeRecord(
  id: t.id,
  stockId: t.stockId,
  isBuy: t.isBuy,
  date: t.date,
  quantity: t.quantity,
  priceCents: t.priceCents,
  feesCents: t.feesCents,
);

class InvestingRepository {
  InvestingRepository(this._db);
  final AppDatabase _db;

  Stream<List<Stock>> watchStocks() => (_db.select(
    _db.stocks,
  )..orderBy([(s) => OrderingTerm.asc(s.symbol)])).watch();

  Stream<List<Trade>> watchTrades() =>
      (_db.select(_db.trades)..orderBy([
            (t) => OrderingTerm.desc(t.date),
            (t) => OrderingTerm.desc(t.id),
          ]))
          .watch();

  Future<int> addStock(String symbol, String name) => _db
      .into(_db.stocks)
      .insert(
        StocksCompanion.insert(
          symbol: symbol.trim().toUpperCase(),
          name: name.trim(),
        ),
      );

  Future<void> setPrice(int stockId, int priceCents, DateTime date) =>
      (_db.update(_db.stocks)..where((s) => s.id.equals(stockId))).write(
        StocksCompanion(
          lastPriceCents: Value(priceCents),
          priceDate: Value(date),
        ),
      );

  Future<List<Trade>> _tradesOf(int stockId) =>
      (_db.select(_db.trades)..where((t) => t.stockId.equals(stockId))).get();

  void _check(Iterable<TradeRecord> proposed) {
    if (!computeFifo(proposed).isValid) throw const OversellException();
  }

  Future<int> addTrade(TradesCompanion t) async {
    final existing = (await _tradesOf(t.stockId.value)).map(toRecord);
    _check([
      ...existing,
      TradeRecord(
        id: 1 << 30, // sorts after existing trades on the same day
        stockId: t.stockId.value,
        isBuy: t.isBuy.value,
        date: t.date.value,
        quantity: t.quantity.value,
        priceCents: t.priceCents.value,
        feesCents: t.feesCents.present ? t.feesCents.value : 0,
      ),
    ]);
    return _db.into(_db.trades).insert(t);
  }

  Future<void> updateTrade(Trade t) async {
    final others = (await _tradesOf(t.stockId))
        .where((o) => o.id != t.id)
        .map(toRecord);
    _check([...others, toRecord(t)]);
    await _db.update(_db.trades).replace(t);
  }

  Future<void> deleteTrade(Trade t) async {
    final others = (await _tradesOf(t.stockId))
        .where((o) => o.id != t.id)
        .map(toRecord);
    _check(others);
    await (_db.delete(_db.trades)..where((x) => x.id.equals(t.id))).go();
  }
}

final investingRepositoryProvider = Provider(
  (ref) => InvestingRepository(ref.watch(databaseProvider)),
);
final stocksProvider = StreamProvider(
  (ref) => ref.watch(investingRepositoryProvider).watchStocks(),
);
final tradesProvider = StreamProvider(
  (ref) => ref.watch(investingRepositoryProvider).watchTrades(),
);
