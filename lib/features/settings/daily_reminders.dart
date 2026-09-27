import '../../core/db/app_database.dart';

/// Notification ids: 10 bedtime, 11 expenses, 100 + tracker id for trackers.
const bedtimeReminderId = 10;
const expenseReminderId = 11;
const trackerReminderBase = 100;
const trackerReminderEnd = 1000;

class DailyReminder {
  const DailyReminder({
    required this.id,
    required this.minutes,
    required this.title,
    required this.body,
    required this.route,
  });

  final int id;
  final int minutes;
  final String title;
  final String body;
  final String route;
}

/// Minutes after midnight for a reminder [lead] minutes before [target],
/// wrapping past midnight (target 00:10 with lead 30 -> 23:40).
int minutesBefore(int target, int lead) =>
    ((target - lead) % 1440 + 1440) % 1440;

/// Every daily reminder that should be scheduled for these settings and trackers.
List<DailyReminder> planDailyReminders(Setting s, Iterable<Tracker> trackers) =>
    [
      if (s.bedtimeReminderEnabled)
        DailyReminder(
          id: bedtimeReminderId,
          minutes: minutesBefore(
            s.targetBedtimeMinutes,
            s.bedtimeReminderLeadMinutes,
          ),
          title: 'Wind down for bed',
          body: 'Bedtime is in ${s.bedtimeReminderLeadMinutes} minutes',
          route: '/sleep',
        ),
      if (s.expenseReminderEnabled)
        DailyReminder(
          id: expenseReminderId,
          minutes: s.expenseReminderMinutes,
          title: 'Log today\'s expenses',
          body: 'Take a minute to add what you spent',
          route: '/money/add',
        ),
      for (final t in trackers)
        if (!t.archived &&
            t.reminderMinutes != null &&
            trackerReminderBase + t.id < trackerReminderEnd)
          DailyReminder(
            id: trackerReminderBase + t.id,
            minutes: t.reminderMinutes!,
            title: t.name,
            body: t.type == 'duration'
                ? 'Time to start your timer'
                : 'Have you done it today?',
            route: '/trackers/${t.id}',
          ),
    ];
