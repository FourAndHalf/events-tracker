/// A buy or sell of one stock, as plain values (no database types).
class TradeRecord {
  const TradeRecord({
    required this.id,
    required this.stockId,
    required this.isBuy,
    required this.date,
    required this.quantity,
    required this.priceCents,
    this.feesCents = 0,
  });

  final int id;
  final int stockId;
  final bool isBuy;
  final DateTime date;
  final int quantity;
  final int priceCents;
  final int feesCents;
}

/// Part of a sale matched against part of one bought lot.
class LotMatch {
  const LotMatch({
    required this.sellTradeId,
    required this.buyTradeId,
    required this.quantity,
    required this.buyDate,
    required this.sellDate,
    required this.costCents,
    required this.proceedsCents,
  });

  final int sellTradeId;
  final int buyTradeId;
  final int quantity;
  final DateTime buyDate;
  final DateTime sellDate;

  /// Buy price of the matched shares plus their share of the buy fees.
  final int costCents;

  /// Sale price of the matched shares minus their share of the sale fees.
  final int proceedsCents;

  int get profitCents => proceedsCents - costCents;
  int get daysHeld => _day(sellDate).difference(_day(buyDate)).inDays;

  /// Short-term if held under 1 year, long-term otherwise.
  bool get isLongTerm {
    final b = _day(buyDate);
    return !_day(sellDate).isBefore(DateTime(b.year + 1, b.month, b.day));
  }
}

/// Shares still held from one buy.
class OpenLot {
  const OpenLot({
    required this.buyTradeId,
    required this.buyDate,
    required this.quantity,
    required this.costCents,
  });

  final int buyTradeId;
  final DateTime buyDate;
  final int quantity;

  /// Remaining buy price plus remaining buy fees.
  final int costCents;
}

class FifoResult {
  const FifoResult({
    required this.matches,
    required this.openLots,
    this.oversoldTradeId,
  });

  final List<LotMatch> matches;
  final List<OpenLot> openLots;

  /// Id of the first sale that tried to sell more than was held, if any.
  final int? oversoldTradeId;

  bool get isValid => oversoldTradeId == null;
  int get heldQuantity => openLots.fold(0, (a, l) => a + l.quantity);
  int get heldCostCents => openLots.fold(0, (a, l) => a + l.costCents);
  int get realizedCents => matches.fold(0, (a, m) => a + m.profitCents);
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

class _Lot {
  _Lot(this.trade)
    : qty = trade.quantity,
      priceCents = trade.priceCents,
      feeLeft = trade.feesCents;
  final TradeRecord trade;
  int qty;
  final int priceCents;
  int feeLeft;
}

/// Splits [amount] for [part] of [total] units. The last part takes the remainder,
/// so the pieces always add up exactly.
int _share(int amount, int part, int total) =>
    part == total ? amount : (amount * part / total).round();

/// Matches sales against buys for ONE stock: oldest shares are sold first (FIFO).
/// Same-day buys count before sells. Stops at the first oversold sale.
FifoResult computeFifo(Iterable<TradeRecord> trades) {
  final sorted = trades.toList()
    ..sort((a, b) {
      final d = _day(a.date).compareTo(_day(b.date));
      if (d != 0) return d;
      if (a.isBuy != b.isBuy) return a.isBuy ? -1 : 1;
      return a.id.compareTo(b.id);
    });

  final lots = <_Lot>[];
  final matches = <LotMatch>[];

  for (final t in sorted) {
    if (t.isBuy) {
      lots.add(_Lot(t));
      continue;
    }
    var remaining = t.quantity;
    var saleFeeLeft = t.feesCents;
    while (remaining > 0) {
      if (lots.isEmpty) {
        return FifoResult(
          matches: matches,
          openLots: _open(lots),
          oversoldTradeId: t.id,
        );
      }
      final lot = lots.first;
      final q = remaining < lot.qty ? remaining : lot.qty;
      final buyFee = _share(lot.feeLeft, q, lot.qty);
      final saleFee = _share(saleFeeLeft, q, remaining);
      matches.add(
        LotMatch(
          sellTradeId: t.id,
          buyTradeId: lot.trade.id,
          quantity: q,
          buyDate: lot.trade.date,
          sellDate: t.date,
          costCents: q * lot.priceCents + buyFee,
          proceedsCents: q * t.priceCents - saleFee,
        ),
      );
      lot.qty -= q;
      lot.feeLeft -= buyFee;
      remaining -= q;
      saleFeeLeft -= saleFee;
      if (lot.qty == 0) lots.removeAt(0);
    }
  }
  return FifoResult(matches: matches, openLots: _open(lots));
}

List<OpenLot> _open(List<_Lot> lots) => [
  for (final l in lots)
    OpenLot(
      buyTradeId: l.trade.id,
      buyDate: l.trade.date,
      quantity: l.qty,
      costCents: l.qty * l.priceCents + l.feeLeft,
    ),
];
