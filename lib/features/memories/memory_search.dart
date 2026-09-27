import '../../core/db/app_database.dart';
import 'memory_dates.dart';

/// Events that fall on [day]: yearly occasions on that month and day (Feb 29
/// on Feb 28 in non-leap years) and one-time events with that exact date.
/// Month- or year-only events have no day to mark.
List<MemoryEvent> eventsOnDay(Iterable<MemoryEvent> events, DateTime day) {
  final d = DateTime(day.year, day.month, day.day);
  return [
    for (final e in events)
      if (e.kind == MemoryKind.occasion.name
          ? (e.month != null &&
                e.day != null &&
                occurrenceIn(d.year, e.month!, e.day!) == d)
          : exactDate(e) == d)
        e,
  ];
}

/// Day-of-month -> events, for every marked day of the given month.
Map<int, List<MemoryEvent>> markedDays(
  Iterable<MemoryEvent> events,
  int year,
  int month,
) {
  final out = <int, List<MemoryEvent>>{};
  final last = DateTime(year, month + 1, 0).day;
  for (var d = 1; d <= last; d++) {
    final hits = eventsOnDay(events, DateTime(year, month, d));
    if (hits.isNotEmpty) out[d] = hits;
  }
  return out;
}

/// Leading blank cells before the 1st in a Monday-first month grid.
int leadingBlanks(int year, int month) =>
    DateTime(year, month, 1).weekday - DateTime.monday;

class MemoryFilter {
  const MemoryFilter({
    this.query = '',
    this.categoryId,
    this.person,
    this.year,
    this.hasMedia = false,
  });

  final String query;
  final int? categoryId;
  final String? person;
  final int? year;
  final bool hasMedia;
}

/// Events matching every active criterion. Text matches title, person, place
/// and description; [withMedia] is the ids of events that have photos/videos.
List<MemoryEvent> filterEvents(
  Iterable<MemoryEvent> events,
  MemoryFilter f, {
  Set<int> withMedia = const {},
}) {
  final q = f.query.trim().toLowerCase();
  bool textMatch(MemoryEvent e) =>
      q.isEmpty ||
      [
        e.title,
        e.person,
        e.place,
        e.description,
      ].any((s) => s != null && s.toLowerCase().contains(q));
  return [
    for (final e in events)
      if (textMatch(e) &&
          (f.categoryId == null || e.categoryId == f.categoryId) &&
          (f.person == null ||
              (e.person ?? '').toLowerCase() == f.person!.toLowerCase()) &&
          (f.year == null || e.year == f.year) &&
          (!f.hasMedia || withMedia.contains(e.id)))
        e,
  ];
}
