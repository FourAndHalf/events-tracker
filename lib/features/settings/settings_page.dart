import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/providers.dart';
import '../../core/db/settings_repository.dart';
import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';

const _currencies = [r'$', '€', '£', '₹', '¥'];

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).value;
    final db = ref.read(databaseProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: s == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(Aura.margin),
              children: [
                const Overline('Sleep goal'),
                const SizedBox(height: 8),
                AuraCard(
                  child: Column(
                    children: [
                      _Row(
                        label: 'Target sleep',
                        value:
                            '${(s.sleepGoalMinutes / 60).toStringAsFixed(1)} h',
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            helpText: 'TARGET SLEEP (HOURS : MINUTES)',
                            initialTime: TimeOfDay(
                              hour: s.sleepGoalMinutes ~/ 60,
                              minute: s.sleepGoalMinutes % 60,
                            ),
                            initialEntryMode: TimePickerEntryMode.input,
                            builder: (ctx, child) => MediaQuery(
                              data: MediaQuery.of(ctx)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            ),
                          );
                          if (t == null) return;
                          final m = t.hour * 60 + t.minute;
                          if (m > 0) {
                            await updateSettings(
                              db,
                              SettingsCompanion(sleepGoalMinutes: Value(m)),
                            );
                          }
                        },
                      ),
                      const Divider(color: Aura.rim),
                      _Row(
                        label: 'Target bedtime',
                        value: TimeOfDay(
                          hour: s.targetBedtimeMinutes ~/ 60,
                          minute: s.targetBedtimeMinutes % 60,
                        ).format(context),
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: s.targetBedtimeMinutes ~/ 60,
                              minute: s.targetBedtimeMinutes % 60,
                            ),
                          );
                          if (t == null) return;
                          await updateSettings(
                            db,
                            SettingsCompanion(
                              targetBedtimeMinutes: Value(
                                t.hour * 60 + t.minute,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Overline('Currency'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final c in _currencies)
                      ChoiceChip(
                        label: Text(c, style: text.labelLarge),
                        selected: s.currencySymbol == c,
                        onSelected: (_) => updateSettings(
                          db,
                          SettingsCompanion(currencySymbol: Value(c)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Overline('Money'),
                const SizedBox(height: 8),
                AuraCard(
                  child: _Row(
                    label: 'Categories & budgets',
                    value: 'Manage',
                    onTap: () => context.push('/money/categories'),
                  ),
                ),
              ],
            ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: Aura.sleep),
            ),
          ],
        ),
      ),
    );
  }
}
