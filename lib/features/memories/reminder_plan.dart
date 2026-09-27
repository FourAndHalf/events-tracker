import '../../core/db/app_database.dart';
import 'memory_dates.dart';

/// Notification ids: occasion reminders use [reminderIdBase] up to (not
/// including) [onThisDayIdBase]; "On this day" ones use [onThisDayIdBase] up to
/// [reminderIdEnd]. Cancelling that whole range clears every memory reminder.
const reminderIdBase = 1000;
const onThisDayIdBase = 2000;
const reminderIdEnd = 3000;

const onThisDayHorizonDays = 60;

class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.when,
    required this.title,
    required this.body,
    required this.route,
  });

  final int id;
  final DateTime when;
  final String title;
  final String body;
  final String route;
}

DateTime _at(DateTime day, int minutes, {int daysBefore = 0}) => DateTime(
  day.year,
  day.month,
  day.day - daysBefore,
  minutes ~/ 60,
  minutes % 60,
);

/// Every notification to schedule from now on: for each event with reminders
/// its next date (an occasion also its following one, in case the app isn't
/// opened for a while), plus, if enabled, one "On this day" per matching day in
/// the next [onThisDayHorizonDays] days. Times already past are dropped.
List<PlannedReminder> planReminders({
  required Iterable<MemoryEvent> events,
  required Map<int, String> categoryNames,
  required DateTime now,
  required int minutes,
  required bool onThisDayEnabled,
}) {
  final out = <PlannedReminder>[];
  var slot = 0;
  final sorted = events.toList()..sort((a, b) => a.id.compareTo(b.id));

  for (final e in sorted) {
    final before = parseRemindDays(e.remindDaysBefore);
    if (!e.remindOnDay && before.isEmpty) continue;
    final next = nextDateOf(e, now);
    if (next == null) continue;
    final occasion = e.kind == MemoryKind.occasion.name;
    final dates = [
      next,
      if (occasion) occurrenceIn(next.year + 1, next.month, e.day!),
    ];
    final cat = categoryNames[e.categoryId] ?? '';
    for (final d in dates) {
      final n = occasion ? ordinalCount(e.year, d.year) : null;
      final nth = n == null ? '' : ' · ${nthLabel(n, cat)}';
      void add(DateTime when, String body) {
        if (!when.isAfter(now) || reminderIdBase + slot >= onThisDayIdBase) {
          return;
        }
        out.add(
          PlannedReminder(
            id: reminderIdBase + slot++,
            when: when,
            title: e.title,
            body: '$body$nth',
            route: '/memories/event/${e.id}',
          ),
        );
      }

      if (e.remindOnDay) add(_at(d, minutes), 'Today');
      for (final k in before) {
        add(_at(d, minutes, daysBefore: k), k == 1 ? 'Tomorrow' : 'In $k days');
      }
    }
  }

  if (onThisDayEnabled) {
    for (var i = 0; i < onThisDayHorizonDays; i++) {
      final day = DateTime(now.year, now.month, now.day + i);
      final when = _at(day, minutes);
      if (!when.isAfter(now)) continue;
      final hits = onThisDay(events, day);
      if (hits.isEmpty) continue;
      final first = hits.first;
      final ago = day.year - first.year!;
      final more = hits.length > 1 ? ' and ${hits.length - 1} more' : '';
      out.add(
        PlannedReminder(
          id: onThisDayIdBase + i,
          when: when,
          title: 'On this day',
          body: '$ago year${ago == 1 ? '' : 's'} ago: ${first.title}$more',
          route: '/memories/event/${first.id}',
        ),
      );
    }
  }

  out.sort((a, b) => a.when.compareTo(b.when));
  return out;
}
