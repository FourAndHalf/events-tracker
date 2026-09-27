import '../../core/charts/series.dart';
import '../../core/db/app_database.dart';
import 'tracker_logic.dart';

/// 1 for each day in [days] a habit was checked, else 0.
List<double> habitPerDay(Iterable<TrackerEntry> entries, List<DateTime> days) {
  final done = {for (final e in entries) dayStart(e.day)};
  return [for (final d in days) done.contains(d) ? 1.0 : 0.0];
}

/// Minutes tracked per day in [days]; a running timer counts up to [now].
List<double> minutesPerDay(
  Iterable<TrackerEntry> entries,
  List<DateTime> days,
  DateTime now,
) {
  final byDay = <DateTime, double>{};
  for (final e in entries) {
    final start = e.startAt;
    if (start == null) continue;
    final d = dayStart(e.day);
    byDay[d] =
        (byDay[d] ?? 0) + entryDuration(start, e.endAt, now).inSeconds / 60;
  }
  return [for (final d in days) byDay[d] ?? 0];
}

/// Share of [days] with a check-off, 0..1.
double completionRate(List<double> perDay) =>
    perDay.isEmpty ? 0 : perDay.where((v) => v > 0).length / perDay.length;
