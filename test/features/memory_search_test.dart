import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/memories/memory_search.dart';
import 'package:flutter_test/flutter_test.dart';

MemoryEvent ev(
  int id, {
  String title = 'E',
  String kind = 'oneTime',
  String precision = 'day',
  int? year,
  int? month,
  int? day,
  int cat = 1,
  String? person,
  String? place,
  String? description,
}) => MemoryEvent(
  id: id,
  title: title,
  kind: kind,
  precision: precision,
  year: year,
  month: month,
  day: day,
  person: person,
  categoryId: cat,
  place: place,
  description: description,
  remindOnDay: false,
  remindDaysBefore: '',
  createdAt: DateTime(2026),
);

void main() {
  group('calendar', () {
    final events = [
      ev(1, kind: 'occasion', year: 1990, month: 9, day: 27),
      ev(2, year: 2019, month: 9, day: 27),
      ev(3, precision: 'month', year: 2026, month: 9),
      ev(4, kind: 'occasion', month: 2, day: 29),
    ];

    test('occasions mark every year, one-time events only their own date', () {
      expect(eventsOnDay(events, DateTime(2026, 9, 27)).map((e) => e.id), [1]);
      expect(eventsOnDay(events, DateTime(2019, 9, 27)).map((e) => e.id), [
        1,
        2,
      ]);
    });

    test('month-only events are not marked on any day', () {
      final m = markedDays(events, 2026, 9);
      expect(m.keys, [27]);
    });

    test('Feb 29 occasions land on Feb 28 in non-leap years', () {
      expect(markedDays(events, 2027, 2).keys, [28]);
      expect(markedDays(events, 2028, 2).keys, [29]);
    });

    test('Monday-first grid offset', () {
      expect(leadingBlanks(2026, 9), 1); // 1 Sep 2026 is a Tuesday
      expect(leadingBlanks(2026, 6), 0); // 1 Jun 2026 is a Monday
      expect(leadingBlanks(2026, 2), 6); // 1 Feb 2026 is a Sunday
    });
  });

  group('filterEvents', () {
    final events = [
      ev(
        1,
        title: 'Goa trip',
        cat: 4,
        person: 'Asha',
        place: 'Goa',
        year: 2019,
      ),
      ev(
        2,
        title: 'Birthday',
        cat: 1,
        person: 'asha',
        year: 2020,
        description: 'Cake at the beach',
      ),
      ev(3, title: 'Move', cat: 3, year: 2019),
    ];
    List<int> ids(MemoryFilter f, {Set<int> media = const {}}) =>
        filterEvents(events, f, withMedia: media).map((e) => e.id).toList();

    test('text searches title, person, place and description', () {
      expect(ids(const MemoryFilter(query: 'goa')), [1]);
      expect(ids(const MemoryFilter(query: 'BEACH')), [2]);
      expect(ids(const MemoryFilter(query: 'asha')), [1, 2]);
      expect(ids(const MemoryFilter(query: '  ')), [1, 2, 3]);
    });

    test('filters combine', () {
      expect(ids(const MemoryFilter(year: 2019)), [1, 3]);
      expect(ids(const MemoryFilter(year: 2019, categoryId: 3)), [3]);
      expect(ids(const MemoryFilter(person: 'Asha')), [1, 2]);
      expect(ids(const MemoryFilter(person: 'Asha', year: 2020)), [2]);
    });

    test('has-media only keeps events with attachments', () {
      expect(ids(const MemoryFilter(hasMedia: true), media: {3}), [3]);
      expect(ids(const MemoryFilter(hasMedia: true)), isEmpty);
    });
  });
}
