import '../../core/db/app_database.dart';
import 'fifo.dart';
import 'investing_repository.dart';
import 'position.dart';

/// Profit/loss of one sale across every lot it used.
class SaleSummary {
  const SaleSummary({
    required this.profitCents,
    required this.minDays,
    required this.maxDays,
    required this.allLongTerm,
  });

  final int profitCents;
  final int minDays;
  final int maxDays;
  final bool allLongTerm;
  bool get isWin => profitCents > 0;
}

class Holding {
  const Holding({
    required this.stock,
    required this.fifo,
    required this.position,
  });

  final Stock stock;
  final FifoResult fifo;
  final Position position;
}

class Portfolio {
  const Portfolio({required this.holdings, required this.sales});

  /// Every stock, including closed ones (quantity 0).
  final List<Holding> holdings;

  /// Sale summaries by sell trade id.
  final Map<int, SaleSummary> sales;

  Iterable<Holding> get open => holdings.where((h) => h.position.isOpen);

  /// Cost of all shares still held (buy fees included).
  int get investedCents => open.fold(0, (a, h) => a + h.position.costCents);

  /// Value at last prices. A stock with no price yet counts at cost, so it adds no fake profit.
  int get valueCents => open.fold(
    0,
    (a, h) => a + (h.position.valueCents ?? h.position.costCents),
  );

  int get unrealizedCents => valueCents - investedCents;
  int get realizedCents => holdings.fold(0, (a, h) => a + h.fifo.realizedCents);
  int get unpricedCount =>
      open.where((h) => h.position.lastPriceCents == null).length;

  Holding? holdingFor(int stockId) {
    for (final h in holdings) {
      if (h.stock.id == stockId) return h;
    }
    return null;
  }
}

Portfolio buildPortfolio(
  List<Stock> stocks,
  List<Trade> trades,
  DateTime today,
) {
  final byStock = <int, List<TradeRecord>>{};
  for (final t in trades) {
    byStock.putIfAbsent(t.stockId, () => []).add(toRecord(t));
  }
  final holdings = <Holding>[];
  final sales = <int, SaleSummary>{};
  for (final s in stocks) {
    final fifo = computeFifo(byStock[s.id] ?? const []);
    holdings.add(
      Holding(
        stock: s,
        fifo: fifo,
        position: positionFrom(fifo, s.lastPriceCents, today),
      ),
    );
    final bySale = <int, List<LotMatch>>{};
    for (final m in fifo.matches) {
      bySale.putIfAbsent(m.sellTradeId, () => []).add(m);
    }
    bySale.forEach((id, ms) {
      final days = ms.map((m) => m.daysHeld);
      sales[id] = SaleSummary(
        profitCents: ms.fold(0, (a, m) => a + m.profitCents),
        minDays: days.reduce((a, b) => a < b ? a : b),
        maxDays: days.reduce((a, b) => a > b ? a : b),
        allLongTerm: ms.every((m) => m.isLongTerm),
      );
    });
  }
  return Portfolio(holdings: holdings, sales: sales);
}

/// Days since the price was last updated, or null if it never was.
int? priceAgeDays(Stock s, DateTime today) {
  final d = s.priceDate;
  if (d == null) return null;
  return DateTime(
    today.year,
    today.month,
    today.day,
  ).difference(DateTime(d.year, d.month, d.day)).inDays;
}

const stalePriceDays = 7;

bool isPriceStale(Stock s, DateTime today) {
  final age = priceAgeDays(s, today);
  return age == null || age >= stalePriceDays;
}
