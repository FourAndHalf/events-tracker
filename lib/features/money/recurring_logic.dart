enum Frequency {
  weekly('Weekly'),
  monthly('Monthly'),
  yearly('Yearly');

  const Frequency(this.label);
  final String label;

  static Frequency parse(String name) =>
      values.firstWhere((f) => f.name == name, orElse: () => monthly);
}

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// [day] clamped to the length of the month, so the 31st becomes the 30th,
/// or the 28th/29th in February.
DateTime _clamped(int year, int month, int day) {
  final last = DateTime(year, month + 1, 0);
  return DateTime(last.year, last.month, day < last.day ? day : last.day);
}

/// The [n]th occurrence (0 = the start date itself).
DateTime occurrence(Frequency f, DateTime start, int n) {
  final s = _dayOnly(start);
  return switch (f) {
    Frequency.weekly => DateTime(s.year, s.month, s.day + 7 * n),
    Frequency.monthly => _clamped(s.year, s.month + n, s.day),
    Frequency.yearly => _clamped(s.year + n, s.month, s.day),
  };
}

/// Dates an expense must be created for: every occurrence after
/// [lastGenerated] (or from the start when null) up to and including [upTo].
/// Counted from the start date each time, so a 31st-of-the-month rule returns
/// to the 31st after a short month instead of drifting.
List<DateTime> dueDates(
  Frequency f,
  DateTime start,
  DateTime? lastGenerated,
  DateTime upTo,
) {
  final limit = _dayOnly(upTo);
  final after = lastGenerated == null ? null : _dayOnly(lastGenerated);
  final out = <DateTime>[];
  for (var n = 0; n < 5000; n++) {
    final d = occurrence(f, start, n);
    if (d.isAfter(limit)) break;
    if (after == null || d.isAfter(after)) out.add(d);
  }
  return out;
}

/// The first occurrence strictly after today.
DateTime nextDue(Frequency f, DateTime start, DateTime now) {
  final today = _dayOnly(now);
  for (var n = 0; n < 5000; n++) {
    final d = occurrence(f, start, n);
    if (d.isAfter(today)) return d;
  }
  return today;
}
