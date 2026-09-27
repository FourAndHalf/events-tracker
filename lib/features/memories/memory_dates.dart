import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';

enum MemoryKind { occasion, oneTime }

enum DatePrecision { day, month, year }

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool _isLeap(int y) => (y % 4 == 0 && y % 100 != 0) || y % 400 == 0;

/// The date an occasion falls on in [year]; Feb 29 becomes Feb 28 in non-leap years.
DateTime occurrenceIn(int year, int month, int day) {
  final d = (month == 2 && day == 29 && !_isLeap(year)) ? 28 : day;
  return DateTime(year, month, d);
}

/// The next time a yearly occasion happens, counting today itself.
DateTime nextOccurrence(int month, int day, DateTime today) {
  final t = _dayOnly(today);
  final thisYear = occurrenceIn(t.year, month, day);
  return thisYear.isBefore(t) ? occurrenceIn(t.year + 1, month, day) : thisYear;
}

int daysLeft(DateTime next, DateTime today) =>
    _dayOnly(next).difference(_dayOnly(today)).inDays;

/// Which birthday/anniversary an occurrence is, or null if the start year is
/// unknown or not before the occurrence.
int? ordinalCount(int? startYear, int occurrenceYear) {
  if (startYear == null) return null;
  final n = occurrenceYear - startYear;
  return n > 0 ? n : null;
}

String ordinal(int n) {
  final mod100 = n % 100;
  if (mod100 >= 11 && mod100 <= 13) return '${n}th';
  return switch (n % 10) {
    1 => '${n}st',
    2 => '${n}nd',
    3 => '${n}rd',
    _ => '${n}th',
  };
}

/// "30th birthday" for a category name like "Birthday"; falls back to
/// "30th anniversary"-style wording only for names we know, else "30 years".
String nthLabel(int n, String categoryName) {
  final c = categoryName.toLowerCase();
  if (c == 'birthday' || c == 'anniversary') return '${ordinal(n)} $c';
  return '$n year${n == 1 ? '' : 's'}';
}

/// Full-date one-time event as a date, or null when only month/year is known.
DateTime? exactDate(MemoryEvent e) =>
    (e.precision == DatePrecision.day.name &&
        e.year != null &&
        e.month != null &&
        e.day != null)
    ? DateTime(e.year!, e.month!, e.day!)
    : null;

/// When the event next needs attention: an occasion's next occurrence, or a
/// one-time event's date if it is still ahead. Null otherwise.
DateTime? nextDateOf(MemoryEvent e, DateTime today) {
  if (e.kind == MemoryKind.occasion.name) {
    if (e.month == null || e.day == null) return null;
    return nextOccurrence(e.month!, e.day!, today);
  }
  final d = exactDate(e);
  if (d == null) return null;
  return d.isBefore(_dayOnly(today)) ? null : d;
}

class ComingUp {
  const ComingUp(this.event, this.date, this.daysLeft);
  final MemoryEvent event;
  final DateTime date;
  final int daysLeft;
}

/// Occasions and dated future events within [withinDays] (inclusive), soonest first.
List<ComingUp> comingUp(
  Iterable<MemoryEvent> events,
  DateTime today, {
  int withinDays = 30,
}) {
  final out = <ComingUp>[];
  for (final e in events) {
    final next = nextDateOf(e, today);
    if (next == null) continue;
    final left = daysLeft(next, today);
    if (left <= withinDays) out.add(ComingUp(e, next, left));
  }
  out.sort((a, b) {
    final c = a.daysLeft.compareTo(b.daysLeft);
    return c != 0 ? c : a.event.title.compareTo(b.event.title);
  });
  return out;
}

/// One-time events with an exact date on today's day and month in an earlier
/// year. Month/year-only events never match; a Feb 29 event matches Feb 28 in
/// non-leap years. Occasions are excluded: they already have a countdown.
List<MemoryEvent> onThisDay(Iterable<MemoryEvent> events, DateTime today) {
  final t = _dayOnly(today);
  return [
    for (final e in events)
      if (e.kind == MemoryKind.oneTime.name &&
          exactDate(e) != null &&
          e.year! < t.year &&
          occurrenceIn(t.year, e.month!, e.day!) == t)
        e,
  ];
}

/// Sort key for the timeline; unknown month/day count as the start of the
/// period, so with newest-first ordering they land after dated entries.
int timelineKey(MemoryEvent e) =>
    (e.year ?? 0) * 10000 + (e.month ?? 0) * 100 + (e.day ?? 0);

class TimelineGroup {
  const TimelineGroup(this.year, this.month, this.events);
  final int year;

  /// Null for events known only by year.
  final int? month;
  final List<MemoryEvent> events;
}

/// One-time events with a known year, grouped by year and month, newest first.
List<TimelineGroup> timelineGroups(Iterable<MemoryEvent> events) {
  final past = events
      .where((e) => e.kind == MemoryKind.oneTime.name && e.year != null)
      .toList();
  past.sort((a, b) {
    final c = timelineKey(b).compareTo(timelineKey(a));
    return c != 0 ? c : a.title.compareTo(b.title);
  });
  final groups = <TimelineGroup>[];
  for (final e in past) {
    final month = e.precision == DatePrecision.year.name ? null : e.month;
    if (groups.isNotEmpty &&
        groups.last.year == e.year &&
        groups.last.month == month) {
      groups.last.events.add(e);
    } else {
      groups.add(TimelineGroup(e.year!, month, [e]));
    }
  }
  return groups;
}

/// "14 Mar 2019", "Mar 2019" or "2019"; occasions without a year show "14 Mar".
String formatMemoryDate(MemoryEvent e) {
  final m = e.month;
  final d = e.day;
  final y = e.year;
  final p = DatePrecision.values.firstWhere(
    (v) => v.name == e.precision,
    orElse: () => DatePrecision.day,
  );
  if (p == DatePrecision.year || (m == null)) return y?.toString() ?? '';
  if (p == DatePrecision.month || d == null) {
    return DateFormat('MMM').format(DateTime(2000, m)) +
        (y == null ? '' : ' $y');
  }
  final full = DateTime(y ?? 2000, m, d);
  return y == null
      ? DateFormat('d MMM').format(full)
      : DateFormat('d MMM y').format(full);
}

/// "3 years ago", "this year", or null for future/unknown years.
String? yearsAgo(MemoryEvent e, DateTime today) {
  final y = e.year;
  if (y == null) return null;
  final n = today.year - y;
  if (n < 0) return null;
  return n == 0 ? 'this year' : '$n year${n == 1 ? '' : 's'} ago';
}

/// Parses "1,3,7" into a sorted list of valid day offsets.
List<int> parseRemindDays(String s) {
  final out =
      s
          .split(',')
          .map((x) => int.tryParse(x.trim()))
          .whereType<int>()
          .where((n) => const [1, 3, 7].contains(n))
          .toSet()
          .toList()
        ..sort();
  return out;
}

String joinRemindDays(Iterable<int> days) =>
    (days.toSet().toList()..sort()).join(',');
