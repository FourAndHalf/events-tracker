enum TrackerType { habit, duration }

DateTime dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _prev(DateTime d) => DateTime(d.year, d.month, d.day - 1);

/// Consecutive days with an entry, ending today. If today has none yet the
/// streak still counts up to yesterday, so it isn't lost before you check off.
int currentStreak(Iterable<DateTime> days, DateTime now) {
  final set = {for (final d in days) dayOf(d)};
  var day = dayOf(now);
  if (!set.contains(day)) day = _prev(day);
  var n = 0;
  while (set.contains(day)) {
    n++;
    day = _prev(day);
  }
  return n;
}

/// The longest run of consecutive days ever.
int bestStreak(Iterable<DateTime> days) {
  final sorted = {for (final d in days) dayOf(d)}.toList()..sort();
  var best = 0;
  var run = 0;
  DateTime? last;
  for (final d in sorted) {
    run = (last != null && _prev(d) == last) ? run + 1 : 1;
    if (run > best) best = run;
    last = d;
  }
  return best;
}

Duration entryDuration(DateTime start, DateTime? end, DateTime now) {
  final d = (end ?? now).difference(start);
  return d.isNegative ? Duration.zero : d;
}
