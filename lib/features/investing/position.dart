import 'fifo.dart';

/// What is held of one stock right now, valued at its last known price.
class Position {
  const Position({
    required this.quantity,
    required this.costCents,
    required this.lastPriceCents,
    required this.oldestDays,
  });

  final int quantity;

  /// Cost of the shares still held, buy fees included.
  final int costCents;
  final int? lastPriceCents;

  /// Days since the oldest still-held shares were bought (0 if none held).
  final int oldestDays;

  bool get isOpen => quantity > 0;

  /// Average cost per share, in cents (rounded).
  int get avgCostCents => quantity == 0 ? 0 : (costCents / quantity).round();
  int? get valueCents =>
      lastPriceCents == null ? null : quantity * lastPriceCents!;

  /// (last price - average cost) x quantity, computed exactly from total cost.
  int? get unrealizedCents =>
      valueCents == null ? null : valueCents! - costCents;
  double? get unrealizedPercent => unrealizedCents == null || costCents == 0
      ? null
      : unrealizedCents! * 100 / costCents;
}

Position positionFrom(FifoResult fifo, int? lastPriceCents, DateTime today) {
  final oldest = fifo.openLots.isEmpty ? null : fifo.openLots.first.buyDate;
  final t = DateTime(today.year, today.month, today.day);
  return Position(
    quantity: fifo.heldQuantity,
    costCents: fifo.heldCostCents,
    lastPriceCents: lastPriceCents,
    oldestDays: oldest == null
        ? 0
        : t.difference(DateTime(oldest.year, oldest.month, oldest.day)).inDays,
  );
}
