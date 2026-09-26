import '../../core/db/app_database.dart';
import '../../core/money/money_format.dart';
import 'fifo.dart';
import 'investing_repository.dart';
import 'portfolio.dart';

/// Monday 00:00 of the week containing [d]. Weeks run Monday to Sunday.
DateTime weekStartOf(DateTime d) =>
    DateTime(d.year, d.month, d.day - (d.weekday - 1));

DateTime weekEndOf(DateTime start) =>
    DateTime(start.year, start.month, start.day + 7);

class ClosedTrade {
  const ClosedTrade({required this.symbol, required this.profitCents});
  final String symbol;
  final int profitCents;
}

class WeeklyReport {
  const WeeklyReport({
    required this.weekStart,
    required this.buyCount,
    required this.sellCount,
    required this.boughtCents,
    required this.soldCents,
    required this.realizedCents,
    required this.yearRealizedCents,
    required this.closedCount,
    required this.wins,
    required this.best,
    required this.worst,
    required this.avgHoldDays,
    required this.valueCents,
    required this.valueChangeCents,
  });

  final DateTime weekStart;
  final int buyCount;
  final int sellCount;

  /// Money invested this week: buys, fees included.
  final int boughtCents;

  /// Money taken out this week: sales minus fees.
  final int soldCents;

  /// Profit or loss of sales made this week.
  final int realizedCents;

  /// Realized P/L from 1 Jan of this week's year to the end of this week.
  final int yearRealizedCents;

  /// Sales made this week, and how many were profitable.
  final int closedCount;
  final int wins;
  final ClosedTrade? best;
  final ClosedTrade? worst;

  /// Average days held across shares sold this week (by quantity), null if none sold.
  final double? avgHoldDays;

  /// Portfolio value as of the last price update in this week (null if unknown).
  final int? valueCents;

  /// Change from the previous recorded week (null if there is no earlier snapshot).
  final int? valueChangeCents;

  int get tradeCount => buyCount + sellCount;
  double? get winRatePercent =>
      closedCount == 0 ? null : wins * 100 / closedCount;
}

/// Builds the report for the week starting [weekStart].
/// [liveValueCents] is used instead of a snapshot when the week is the current one.
WeeklyReport buildWeeklyReport({
  required DateTime weekStart,
  required List<Stock> stocks,
  required List<Trade> trades,
  required List<WeeklySnapshot> snapshots,
  required DateTime today,
  required int liveValueCents,
}) {
  final start = weekStart;
  final end = weekEndOf(start);
  bool inWeek(DateTime d) => !d.isBefore(start) && d.isBefore(end);
  DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);

  var buys = 0, sells = 0, bought = 0, sold = 0;
  for (final t in trades) {
    if (!inWeek(day(t.date))) continue;
    if (t.isBuy) {
      buys++;
      bought += t.quantity * t.priceCents + t.feesCents;
    } else {
      sells++;
      sold += t.quantity * t.priceCents - t.feesCents;
    }
  }

  final yearStart = DateTime(end.subtract(const Duration(days: 1)).year);
  final symbolOf = {for (final s in stocks) s.id: s.symbol};
  final byStock = <int, List<TradeRecord>>{};
  for (final t in trades) {
    byStock.putIfAbsent(t.stockId, () => []).add(toRecord(t));
  }

  var realized = 0, yearRealized = 0, holdWeighted = 0, holdQty = 0;
  final saleProfit = <int, int>{};
  final saleSymbol = <int, String>{};
  byStock.forEach((stockId, list) {
    for (final m in computeFifo(list).matches) {
      final d = day(m.sellDate);
      if (!d.isBefore(yearStart) && d.isBefore(end)) {
        yearRealized += m.profitCents;
      }
      if (!inWeek(d)) continue;
      realized += m.profitCents;
      holdWeighted += m.daysHeld * m.quantity;
      holdQty += m.quantity;
      saleProfit[m.sellTradeId] =
          (saleProfit[m.sellTradeId] ?? 0) + m.profitCents;
      saleSymbol[m.sellTradeId] = symbolOf[stockId] ?? '';
    }
  });
  final closed = [
    for (final e in saleProfit.entries)
      ClosedTrade(symbol: saleSymbol[e.key]!, profitCents: e.value),
  ];

  final isCurrent = start == weekStartOf(today);
  final thisSnap = snapshots.where((s) => s.weekStart == start).firstOrNull;
  final value = isCurrent ? liveValueCents : thisSnap?.valueCents;
  final earlier = snapshots.where((s) => s.weekStart.isBefore(start)).toList()
    ..sort((a, b) => b.weekStart.compareTo(a.weekStart));

  return WeeklyReport(
    weekStart: start,
    buyCount: buys,
    sellCount: sells,
    boughtCents: bought,
    soldCents: sold,
    realizedCents: realized,
    yearRealizedCents: yearRealized,
    closedCount: closed.length,
    wins: closed.where((c) => c.profitCents > 0).length,
    best: closed.isEmpty
        ? null
        : closed.reduce((a, b) => b.profitCents > a.profitCents ? b : a),
    worst: closed.isEmpty
        ? null
        : closed.reduce((a, b) => b.profitCents < a.profitCents ? b : a),
    avgHoldDays: holdQty == 0 ? null : holdWeighted / holdQty,
    valueCents: value,
    valueChangeCents: value == null || earlier.isEmpty
        ? null
        : value - earlier.first.valueCents,
  );
}

/// Weeks worth listing: any week with a trade or a snapshot, plus the current one. Newest first.
List<DateTime> reportWeeks(
  List<Trade> trades,
  List<WeeklySnapshot> snapshots,
  DateTime today,
) {
  final weeks = <DateTime>{
    weekStartOf(today),
    for (final t in trades) weekStartOf(t.date),
    for (final s in snapshots) weekStartOf(s.weekStart),
  }.toList()..sort((a, b) => b.compareTo(a));
  return weeks;
}

/// The snapshot to store for the week containing [today].
({DateTime weekStart, int investedCents, int valueCents}) snapshotNow(
  Portfolio p,
  DateTime today,
) => (
  weekStart: weekStartOf(today),
  investedCents: p.investedCents,
  valueCents: p.valueCents,
);

/// The next Sunday at [minutesAfterMidnight] that is still in the future.
DateTime nextReportTime(DateTime now, int minutesAfterMidnight) {
  var d = DateTime(
    now.year,
    now.month,
    now.day,
    minutesAfterMidnight ~/ 60,
    minutesAfterMidnight % 60,
  );
  d = d.add(Duration(days: (DateTime.sunday - d.weekday) % 7));
  // add() on a local DateTime can shift by an hour across DST, so rebuild the wall-clock time.
  d = DateTime(
    d.year,
    d.month,
    d.day,
    minutesAfterMidnight ~/ 60,
    minutesAfterMidnight % 60,
  );
  return d.isAfter(now)
      ? d
      : DateTime(d.year, d.month, d.day + 7, d.hour, d.minute);
}

/// Headline numbers for the Sunday notification.
String weeklyHeadline(WeeklyReport r, String symbol) {
  final parts = <String>[
    r.tradeCount == 0
        ? 'No trades'
        : '${r.tradeCount} trade${r.tradeCount == 1 ? '' : 's'}',
    'Realized ${_signed(r.realizedCents, symbol)}',
    if (r.valueCents != null) 'Portfolio ${formatMoney(r.valueCents!, symbol)}',
    if (r.valueChangeCents != null)
      '(${_signed(r.valueChangeCents!, symbol)} vs last week)',
  ];
  return parts.join(' · ');
}

String _signed(int cents, String symbol) =>
    cents > 0 ? '+${formatMoney(cents, symbol)}' : formatMoney(cents, symbol);
