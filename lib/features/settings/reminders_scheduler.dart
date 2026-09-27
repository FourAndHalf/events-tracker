import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/settings_repository.dart';
import '../../core/notifications/report_notifier.dart';
import '../trackers/trackers_repository.dart';
import 'daily_reminders.dart';

/// Keeps the daily reminders (bedtime, expenses, trackers) in step with the
/// settings and trackers: any change cancels and reschedules them all.
final dailyReminderSchedulerProvider = Provider<void>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final trackers = ref.watch(trackersProvider).value;
  if (settings == null || trackers == null) return;
  final notifier = ref.read(reportNotifierProvider);
  final plan = planDailyReminders(settings, trackers);
  unawaited(() async {
    await notifier.cancelRange(bedtimeReminderId, expenseReminderId + 1);
    await notifier.cancelRange(trackerReminderBase, trackerReminderEnd);
    for (final r in plan) {
      await notifier.scheduleDaily(
        id: r.id,
        minutes: r.minutes,
        title: r.title,
        body: r.body,
        route: r.route,
      );
    }
  }());
});
