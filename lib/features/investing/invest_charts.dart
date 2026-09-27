import '../../core/charts/series.dart';
import '../../core/db/app_database.dart';
import 'portfolio.dart';

/// Snapshots for the last [weeks] weeks, oldest first (weeks you never opened
/// the app have none and are simply skipped).
List<WeeklySnapshot> snapshotsForWeeks(
  Iterable<WeeklySnapshot> snapshots,
  List<DateTime> weeks,
) {
  final set = weeks.toSet();
  return [
    for (final s in snapshots)
      if (set.contains(mondayOf(s.weekStart))) s,
  ]..sort((a, b) => a.weekStart.compareTo(b.weekStart));
}

/// Realized profit or loss (cents) of sales made in each of [weeks].
List<int> realizedPerWeek(Portfolio p, List<DateTime> weeks) {
  final byWeek = <DateTime, int>{};
  for (final h in p.holdings) {
    for (final m in h.fifo.matches) {
      final w = mondayOf(m.sellDate);
      byWeek[w] = (byWeek[w] ?? 0) + m.proceedsCents - m.costCents;
    }
  }
  return [for (final w in weeks) byWeek[w] ?? 0];
}

class Allocation {
  const Allocation(this.symbol, this.valueCents, this.percent);

  final String symbol;
  final int valueCents;
  final double percent;
}

/// Share of the portfolio value in each held stock, biggest first. A stock
/// without a price counts at cost, like the portfolio total.
List<Allocation> allocation(Portfolio p) {
  final total = p.valueCents;
  if (total <= 0) return const [];
  return [
    for (final h in p.open)
      Allocation(
        h.stock.symbol,
        h.position.valueCents ?? h.position.costCents,
        (h.position.valueCents ?? h.position.costCents) * 100 / total,
      ),
  ]..sort((a, b) => b.valueCents.compareTo(a.valueCents));
}
