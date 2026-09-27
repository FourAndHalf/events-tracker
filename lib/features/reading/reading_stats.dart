/// A finished (or running) reading session reduced to what stats need.
class SessionStat {
  const SessionStat({
    required this.start,
    required this.duration,
    required this.pages,
  });
  final DateTime start;
  final Duration duration;
  final int pages;
}

DateTime dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

/// Monday 00:00 of the week containing [d].
DateTime weekOf(DateTime d) =>
    DateTime(d.year, d.month, d.day - (d.weekday - DateTime.monday));

Map<DateTime, Duration> timePerDay(Iterable<SessionStat> s) {
  final out = <DateTime, Duration>{};
  for (final x in s) {
    out.update(
      dayOf(x.start),
      (v) => v + x.duration,
      ifAbsent: () => x.duration,
    );
  }
  return out;
}

Map<DateTime, Duration> timePerWeek(Iterable<SessionStat> s) {
  final out = <DateTime, Duration>{};
  for (final x in s) {
    out.update(
      weekOf(x.start),
      (v) => v + x.duration,
      ifAbsent: () => x.duration,
    );
  }
  return out;
}

Map<DateTime, int> pagesPerDay(Iterable<SessionStat> s) {
  final out = <DateTime, int>{};
  for (final x in s) {
    out.update(dayOf(x.start), (v) => v + x.pages, ifAbsent: () => x.pages);
  }
  return out;
}

/// Consecutive days with reading, ending today. If nothing was read today yet,
/// the streak still counts up to yesterday so it isn't lost before you read.
int readingStreak(Iterable<SessionStat> s, DateTime now) {
  final days = {for (final x in s) dayOf(x.start)};
  var day = dayOf(now);
  if (!days.contains(day)) day = day.subtract(const Duration(days: 1));
  var n = 0;
  while (days.contains(day)) {
    n++;
    day = DateTime(day.year, day.month, day.day - 1);
  }
  return n;
}
