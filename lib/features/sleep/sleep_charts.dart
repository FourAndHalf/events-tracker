import 'dart:math' as math;

import '../../core/db/app_database.dart';
import '../../core/charts/series.dart';
import 'sleep_logic.dart';

/// Hours slept per day, a night counting toward the day you woke up.
List<double> sleepHoursPerDay(
  Iterable<SleepSession> sessions,
  List<DateTime> days,
) {
  final byDay = <DateTime, double>{};
  for (final s in sessions) {
    final wake = s.wakeAt;
    if (wake == null) continue;
    final d = dayStart(wake);
    byDay[d] = (byDay[d] ?? 0) + sleepDuration(s.sleepAt, wake).inMinutes / 60;
  }
  return [for (final d in days) byDay[d] ?? 0];
}

/// Bedtimes (as ordered minutes, so 00:30 sorts after 23:00) of nights that
/// ended within [days], oldest first.
List<({DateTime day, int minutes})> bedtimesIn(
  Iterable<SleepSession> sessions,
  List<DateTime> days,
) {
  final set = days.toSet();
  final out = [
    for (final s in sessions)
      if (s.wakeAt != null && set.contains(dayStart(s.wakeAt!)))
        (
          day: dayStart(s.wakeAt!),
          minutes: bedtimeOrder(minutesOfDay(s.sleepAt)),
        ),
  ]..sort((a, b) => a.day.compareTo(b.day));
  return out;
}

/// Average bedtime (ordered minutes) and how much it varies (standard
/// deviation in minutes; lower is more consistent). Null with no nights.
({double average, double spread})? bedtimeConsistency(List<int> minutes) {
  if (minutes.isEmpty) return null;
  final avg = minutes.reduce((a, b) => a + b) / minutes.length;
  final variance =
      minutes.map((m) => math.pow(m - avg, 2)).reduce((a, b) => a + b) /
      minutes.length;
  return (average: avg, spread: math.sqrt(variance));
}

/// "23:12" for ordered minutes (values past 1440 wrap to after midnight).
String clockOf(double orderedMinutes) {
  final m = orderedMinutes.round() % 1440;
  return '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';
}
