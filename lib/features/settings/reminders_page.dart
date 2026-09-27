import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import '../../core/db/settings_repository.dart';
import '../../core/notifications/report_notifier.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
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
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          const Overline('Bedtime', color: Aura.sleep),
          const SizedBox(height: 8),
          AuraCard(
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
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final m in const [15, 30, 60])
                        ChoiceChip(
                          label: Text('$m min before'),
                          selected: s.bedtimeReminderLeadMinutes == m,
                          onSelected: (_) => updateSettings(
                            db,
                            SettingsCompanion(
                              bedtimeReminderLeadMinutes: Value(m),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Overline('Money', color: Aura.money),
          const SizedBox(height: 8),
          AuraCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Log today\'s expenses'),
                  subtitle: const Text(
                    'A daily reminder to add what you spent',
                  ),
                  value: s.expenseReminderEnabled,
                  onChanged: (v) async {
                    if (v) await ask();
                    await updateSettings(
                      db,
                      SettingsCompanion(expenseReminderEnabled: Value(v)),
                    );
                  },
                ),
                if (s.expenseReminderEnabled) ...[
                  const Divider(color: Aura.rim),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Time'),
                    trailing: Text(
                      _clock(context, s.expenseReminderMinutes),
                      style: text.labelLarge,
                    ),
                    onTap: () async {
                      final m = await _pickTime(
                        context,
                        s.expenseReminderMinutes,
                      );
                      if (m != null) {
                        await updateSettings(
                          db,
                          SettingsCompanion(expenseReminderMinutes: Value(m)),
                        );
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Overline('Trackers', color: Aura.habit),
          const SizedBox(height: 8),
          AuraCard(
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
                                style: text.labelLarge,
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
          const SizedBox(height: 24),
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
