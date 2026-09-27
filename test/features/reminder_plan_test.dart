import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/memories/reminder_plan.dart';
import 'package:flutter_test/flutter_test.dart';

MemoryEvent ev(
  int id, {
  String title = 'E',
  String kind = 'occasion',
  String precision = 'day',
  int? year,
  int? month,
  int? day,
  bool onDay = false,
  String before = '',
  int cat = 1,
}) => MemoryEvent(
  id: id,
  title: title,
  kind: kind,
  precision: precision,
  year: year,
  month: month,
  day: day,
  categoryId: cat,
  remindOnDay: onDay,
  remindDaysBefore: before,
  createdAt: DateTime(2026),
);

List<PlannedReminder> plan(
  List<MemoryEvent> events,
  DateTime now, {
  bool otd = false,
}) => planReminders(
  events: events,
  categoryNames: const {1: 'Birthday', 2: 'Anniversary'},
  now: now,
  minutes: 540,
  onThisDayEnabled: otd,
);

void main() {
  final now = DateTime(2026, 9, 27, 12);

  test('events without reminders plan nothing', () {
    expect(plan([ev(1, month: 10, day: 5)], now), isEmpty);
  });

  test('on the day and days before, with the birthday count', () {
    final r = plan([
      ev(
        1,
        title: 'Mum',
        year: 1966,
        month: 10,
        day: 5,
        onDay: true,
        before: '1,7',
      ),
    ], now);
    // Next occurrence (5 Oct 2026) plus the one after (5 Oct 2027).
    expect(r.take(3).map((x) => x.when), [
      DateTime(2026, 9, 28, 9),
      DateTime(2026, 10, 4, 9),
      DateTime(2026, 10, 5, 9),
    ]);
    expect(r.first.body, 'In 7 days · 60th birthday');
    expect(r[1].body, 'Tomorrow · 60th birthday');
    expect(r[2].body, 'Today · 60th birthday');
    expect(r[2].route, '/memories/event/1');
    expect(r.length, 6);
    expect(r.last.body, 'Today · 61st birthday');
  });

  test('reminder times already past are dropped', () {
    // Event is tomorrow at 09:00 local; "1 day before" was today 09:00, past by noon.
    final r = plan([ev(1, month: 9, day: 28, onDay: true, before: '1')], now);
    expect(r.first.when, DateTime(2026, 9, 28, 9));
    expect(r.first.body, 'Today');
  });

  test('a Feb 29 occasion is reminded on Feb 28 in non-leap years', () {
    final r = plan([ev(1, month: 2, day: 29, onDay: true)], now);
    expect(r.first.when, DateTime(2027, 2, 28, 9));
    expect(r[1].when, DateTime(2028, 2, 29, 9));
  });

  test('one-time events remind only while in the future; month-only never', () {
    final r = plan([
      ev(1, kind: 'oneTime', year: 2026, month: 10, day: 1, onDay: true),
      ev(2, kind: 'oneTime', year: 2020, month: 1, day: 1, onDay: true),
      ev(
        3,
        kind: 'oneTime',
        precision: 'month',
        year: 2026,
        month: 10,
        onDay: true,
      ),
    ], now);
    expect(r.map((x) => x.route), ['/memories/event/1']);
  });

  test('ids stay in the reminder range and are unique', () {
    final events = [
      for (var i = 1; i <= 30; i++)
        ev(i, month: 12, day: i, onDay: true, before: '1,3,7'),
    ];
    final r = plan(events, now, otd: true);
    final ids = r.map((x) => x.id).toList();
    expect(ids.toSet().length, ids.length);
    expect(ids.every((i) => i >= reminderIdBase && i < reminderIdEnd), isTrue);
  });

  test(
    'on this day: only matching days in the horizon, joined when several',
    () {
      final events = [
        ev(1, title: 'Goa', kind: 'oneTime', year: 2019, month: 10, day: 2),
        ev(2, title: 'Party', kind: 'oneTime', year: 2021, month: 10, day: 2),
        ev(
          3,
          title: 'Vague',
          kind: 'oneTime',
          precision: 'month',
          year: 2019,
          month: 10,
        ),
      ];
      final r = plan(events, now, otd: true);
      expect(r, hasLength(1));
      expect(r.single.title, 'On this day');
      expect(r.single.when, DateTime(2026, 10, 2, 9));
      expect(r.single.body, '7 years ago: Goa and 1 more');
      expect(r.single.id, onThisDayIdBase + 5);
      expect(plan(events, now, otd: false), isEmpty);
    },
  );
}
