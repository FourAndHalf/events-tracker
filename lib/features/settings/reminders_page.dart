import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import '../../core/db/settings_repository.dart';
import '../../core/notifications/report_notifier.dart';
import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/pearl_widgets.dart';
import '../trackers/trackers_repository.dart';
import 'daily_reminders.dart';

String _clock(BuildContext context, int minutes) =>
    TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60).format(context);

Future<int?> _pickTime(BuildContext context, int initial) async {
  final t = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: initial ~/ 60, minute: initial % 60),
  );
  return t == null ? null : t.hour * 60 + t.minute;
}

/// One place for the daily reminders: bedtime, expenses and each tracker.
class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).value;
    final trackers = (ref.watch(trackersProvider).value ?? const <Tracker>[])
        .where((t) => !t.archived)
        .toList();
    final db = ref.watch(databaseProvider);
    final text = Theme.of(context).textTheme;
    if (s == null) {
      return Scaffold(appBar: AppBar(title: const Text('Reminders')));
    }

    Future<void> ask() => ref.read(reportNotifierProvider).requestPermission();

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: ListView(
        padding: const EdgeInsets.all(Pearl.margin),
        children: [
          const SectionTitle('Bedtime'),
          Module(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Bedtime reminder'),
                  subtitle: Text(
                    s.bedtimeReminderEnabled
                        ? 'Every day at ${_clock(context, minutesBefore(s.targetBedtimeMinutes, s.bedtimeReminderLeadMinutes))}'
                        : 'A nudge before your target bedtime',
                  ),
                  value: s.bedtimeReminderEnabled,
                  onChanged: (v) async {
                    if (v) await ask();
                    await updateSettings(
                      db,
                      SettingsCompanion(bedtimeReminderEnabled: Value(v)),
                    );
                  },
                ),
                if (s.bedtimeReminderEnabled) ...[
                  Text('How early', style: text.bodySmall),
                  const SizedBox(height: 8),
                  Segmented<int>(
                    expand: true,
                    segments: const [
                      (15, '15 min'),
                      (30, '30 min'),
                      (60, '60 min'),
                    ],
                    selected: s.bedtimeReminderLeadMinutes,
                    onChanged: (m) => updateSettings(
                      db,
                      SettingsCompanion(bedtimeReminderLeadMinutes: Value(m)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: Pearl.spaceLg),
          const SectionTitle('Trackers'),
          Module(
            child: trackers.isEmpty
                ? Text('No trackers yet.', style: text.bodySmall)
                : Column(
                    children: [
                      for (final t in trackers)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(t.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                t.reminderMinutes == null
                                    ? 'Off'
                                    : _clock(context, t.reminderMinutes!),
                              ),
                              if (t.reminderMinutes != null)
                                IconButton(
                                  tooltip: 'Turn off reminder for ${t.name}',
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () => ref
                                      .read(trackersRepositoryProvider)
                                      .updateTracker(
                                        t.copyWith(
                                          reminderMinutes: const Value(null),
                                        ),
                                      ),
                                ),
                            ],
                          ),
                          onTap: () async {
                            final m = await _pickTime(
                              context,
                              t.reminderMinutes ?? 20 * 60,
                            );
                            if (m == null) return;
                            await ask();
                            await ref
                                .read(trackersRepositoryProvider)
                                .updateTracker(
                                  t.copyWith(reminderMinutes: Value(m)),
                                );
                          },
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: Pearl.spaceLg),
          Text(
            'Reminders for birthdays and memories are set on each memory. '
            'Times can arrive a little late because the app avoids the exact-alarm permission.',
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}
