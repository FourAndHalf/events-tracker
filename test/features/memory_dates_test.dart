import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/memories/memory_dates.dart';
import 'package:flutter_test/flutter_test.dart';

MemoryEvent ev({
  int id = 1,
  String title = 'E',
  String kind = 'oneTime',
  String precision = 'day',
  int? year,
  int? month,
  int? day,
}) => MemoryEvent(
  id: id,
  title: title,
  kind: kind,
  precision: precision,
  year: year,
  month: month,
  day: day,
  categoryId: 1,
  remindOnDay: false,
  remindDaysBefore: '',
  createdAt: DateTime(2026),
);

void main() {
  group('nextOccurrence', () {
    test('later this year, today itself, and rolling over the year end', () {
      expect(
        nextOccurrence(10, 5, DateTime(2026, 9, 27)),
        DateTime(2026, 10, 5),
      );
      expect(
        nextOccurrence(9, 27, DateTime(2026, 9, 27, 15)),
        DateTime(2026, 9, 27),
      );
      expect(
        nextOccurrence(1, 2, DateTime(2026, 12, 30)),
        DateTime(2027, 1, 2),
      );
      expect(
        nextOccurrence(9, 26, DateTime(2026, 9, 27)),
        DateTime(2027, 9, 26),
      );
    });

    test('Feb 29 falls on Feb 28 in non-leap years only', () {
      expect(
        nextOccurrence(2, 29, DateTime(2026, 3, 1)),
        DateTime(2027, 2, 28),
      );
      expect(
        nextOccurrence(2, 29, DateTime(2027, 3, 1)),
        DateTime(2028, 2, 29),
      );
      expect(
        nextOccurrence(2, 29, DateTime(2026, 1, 10)),
        DateTime(2026, 2, 28),
      );
      expect(
        nextOccurrence(2, 29, DateTime(2100, 1, 10)),
        DateTime(2100, 2, 28),
      );
    });

    test('days left counts calendar days', () {
      expect(daysLeft(DateTime(2026, 10, 5), DateTime(2026, 9, 27, 23)), 8);
      expect(daysLeft(DateTime(2026, 9, 27), DateTime(2026, 9, 27, 9)), 0);
    });
  });

  group('Nth count', () {
    test('counts from the start year, null when unknown or not yet', () {
      expect(ordinalCount(1990, 2026), 36);
      expect(ordinalCount(null, 2026), isNull);
      expect(ordinalCount(2026, 2026), isNull);
    });

    test('ordinal suffixes including 11-13', () {
      expect([1, 2, 3, 4, 11, 12, 13, 21, 22, 23, 101, 111].map(ordinal), [
        '1st',
        '2nd',
        '3rd',
        '4th',
        '11th',
        '12th',
        '13th',
        '21st',
        '22nd',
        '23rd',
        '101st',
        '111th',
      ]);
    });

    test('label wording follows the category', () {
      expect(nthLabel(30, 'Birthday'), '30th birthday');
      expect(nthLabel(5, 'anniversary'), '5th anniversary');
      expect(nthLabel(1, 'Travel'), '1 year');
      expect(nthLabel(4, 'Travel'), '4 years');
    });
  });

  group('comingUp', () {
    final today = DateTime(2026, 12, 20);
    test(
      'includes occasions across year end and future dated events, sorted',
      () {
        final list = comingUp([
          ev(id: 1, title: 'Far', kind: 'occasion', month: 3, day: 1),
          ev(id: 2, title: 'NYE bday', kind: 'occasion', month: 1, day: 5),
          ev(id: 3, title: 'Trip', year: 2026, month: 12, day: 25),
          ev(id: 4, title: 'Old', year: 2020, month: 12, day: 25),
          ev(id: 5, title: 'Vague', precision: 'month', year: 2026, month: 12),
        ], today);
        expect(list.map((c) => c.event.title), ['Trip', 'NYE bday']);
        expect(list.map((c) => c.daysLeft), [5, 16]);
      },
    );

    test('30 days is inclusive', () {
      final l = comingUp([ev(kind: 'occasion', month: 1, day: 19)], today);
      expect(l.single.daysLeft, 30);
      expect(
        comingUp([ev(kind: 'occasion', month: 1, day: 20)], today),
        isEmpty,
      );
    });
  });

  group('onThisDay', () {
    final today = DateTime(2026, 9, 27);
    test('matches exact dates from earlier years only', () {
      final m = onThisDay([
        ev(id: 1, year: 2019, month: 9, day: 27),
        ev(id: 2, year: 2026, month: 9, day: 27), // this year
        ev(id: 3, year: 2019, month: 9, day: 28),
        ev(id: 4, precision: 'month', year: 2019, month: 9),
        ev(id: 5, precision: 'year', year: 2019),
        ev(id: 6, kind: 'occasion', year: 1990, month: 9, day: 27),
      ], today);
      expect(m.map((e) => e.id), [1]);
    });

    test('Feb 29 memories show on Feb 28 in non-leap years', () {
      final e = ev(year: 2020, month: 2, day: 29);
      expect(onThisDay([e], DateTime(2027, 2, 28)), [e]);
      expect(onThisDay([e], DateTime(2028, 2, 29)), [e]);
      expect(onThisDay([e], DateTime(2027, 3, 1)), isEmpty);
    });
  });

  group('timeline', () {
    test('groups by year and month, newest first, approximate dates last in period', () {
      final g = timelineGroups([
        ev(id: 1, title: 'a', year: 2024, month: 5, day: 2),
        ev(id: 2, title: 'b', year: 2024, month: 5, day: 20),
        ev(id: 3, title: 'c', precision: 'month', year: 2024, month: 5),
        ev(id: 4, title: 'd', precision: 'year', year: 2024),
        ev(id: 5, title: 'e', year: 2025, month: 1, day: 1),
        ev(id: 6, kind: 'occasion', year: 1990, month: 1, day: 1),
      ]);
      expect(g.map((x) => (x.year, x.month)), [
        (2025, 1),
        (2024, 5),
        (2024, null),
      ]);
      expect(g[1].events.map((e) => e.id), [2, 1, 3]);
    });
  });

  test('formats exact, month and year dates', () {
    expect(formatMemoryDate(ev(year: 2019, month: 3, day: 14)), '14 Mar 2019');
    expect(
      formatMemoryDate(ev(precision: 'month', year: 2019, month: 3)),
      'Mar 2019',
    );
    expect(formatMemoryDate(ev(precision: 'year', year: 2019)), '2019');
    expect(formatMemoryDate(ev(kind: 'occasion', month: 3, day: 14)), '14 Mar');
  });

  test('countdown wording', () {
    expect([0, 1, 5].map(countdownText), ['Today', 'Tomorrow', 'in 5 days']);
  });

  test('years ago and reminder day parsing', () {
    final t = DateTime(2026, 9, 27);
    expect(yearsAgo(ev(year: 2023), t), '3 years ago');
    expect(yearsAgo(ev(year: 2025), t), '1 year ago');
    expect(yearsAgo(ev(year: 2026), t), 'this year');
    expect(yearsAgo(ev(year: 2027), t), isNull);
    expect(parseRemindDays('7, 1,x,5,1'), [1, 7]);
    expect(joinRemindDays([7, 1, 1]), '1,7');
  });
}
