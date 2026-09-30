import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/settings/daily_reminders.dart';
import 'package:flutter_test/flutter_test.dart';

Setting settings({
  bool bed = false,
  int lead = 30,
  int target = 1380,
  bool exp = false,
  int expAt = 1260,
}) => Setting(
  id: 1,
  currencySymbol: r'$',
  sleepGoalMinutes: 480,
  targetBedtimeMinutes: target,
  weeklyReportEnabled: true,
  weeklyReportMinutes: 1140,
  memoryRemindMinutes: 540,
  onThisDayEnabled: false,
  bedtimeReminderEnabled: bed,
  bedtimeReminderLeadMinutes: lead,
  expenseReminderEnabled: exp,
  expenseReminderMinutes: expAt,
  dailyPageGoal: 25,
);

Tracker tracker(
  int id, {
  int? at,
  bool archived = false,
  String type = 'habit',
}) => Tracker(
  id: id,
  name: 'T$id',
  icon: 'star',
  type: type,
  archived: archived,
  reminderMinutes: at,
);

void main() {
  test('minutesBefore wraps past midnight', () {
    expect(minutesBefore(1380, 30), 1350); // 23:00 -> 22:30
    expect(minutesBefore(10, 30), 1420); // 00:10 -> 23:40
    expect(minutesBefore(0, 60), 1380);
  });

  test('nothing enabled plans nothing', () {
    expect(planDailyReminders(settings(), [tracker(1)]), isEmpty);
  });

  test('bedtime and expense reminders use their settings', () {
    final r = planDailyReminders(
      settings(bed: true, lead: 15, exp: true, expAt: 1200),
      [],
    );
    expect(r.map((x) => (x.id, x.minutes, x.route)), [
      (bedtimeReminderId, 1365, '/sleep'),
      (expenseReminderId, 1200, '/money/add'),
    ]);
    expect(r.first.body, contains('15 minutes'));
  });

  test(
    'only active trackers with a time get a reminder, ids offset by tracker id',
    () {
      final r = planDailyReminders(settings(), [
        tracker(1, at: 480),
        tracker(2),
        tracker(3, at: 600, archived: true),
        tracker(4, at: 1200, type: 'duration'),
      ]);
      expect(r.map((x) => (x.id, x.minutes)), [(101, 480), (104, 1200)]);
      expect(r.last.body, 'Time to start your timer');
      expect(r.first.route, '/trackers/1');
    },
  );

  test('tracker ids beyond the reserved range are skipped', () {
    final ids = planDailyReminders(settings(), [
      tracker(899, at: 480),
      tracker(900, at: 480),
    ]).map((x) => x.id);
    expect(ids, [999]);
  });
}
