import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/settings_repository.dart';
import '../../core/notifications/report_notifier.dart';
import 'memories_repository.dart';
import 'reminder_plan.dart';

/// Reschedules every memory reminder whenever events, categories or the
/// settings change (so edits, deletes and imports are all picked up), and on
/// each app start.
final memoryReminderSchedulerProvider = Provider<void>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final events = ref.watch(memoryEventsProvider).value;
  final cats = ref.watch(memoryCategoriesProvider).value;
  if (settings == null || events == null || cats == null) return;
  final notifier = ref.read(reportNotifierProvider);

  final plan = planReminders(
    events: events,
    categoryNames: {for (final c in cats) c.id: c.name},
    now: DateTime.now(),
    minutes: settings.memoryRemindMinutes,
    onThisDayEnabled: settings.onThisDayEnabled,
  );
  unawaited(() async {
    await notifier.cancelRange(reminderIdBase, reminderIdEnd);
    for (final r in plan) {
      await notifier.scheduleAt(
        id: r.id,
        when: r.when,
        title: r.title,
        body: r.body,
        route: r.route,
      );
    }
  }());
});
