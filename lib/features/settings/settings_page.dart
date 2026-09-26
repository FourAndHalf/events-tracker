import 'package:drift/drift.dart' show Value;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/providers.dart';
import '../../core/db/settings_repository.dart';
import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'backup_codec.dart';
import 'backup_service.dart';

const _currencies = [r'$', '€', '£', '₹', '¥'];

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _toast(BuildContext context, String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(backupServiceProvider).exportAndShare();
    } catch (e) {
      if (context.mounted) _toast(context, 'Export failed: $e');
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final service = ref.read(backupServiceProvider);
    final picked = await FilePicker.pickFiles(type: FileType.any);
    final path = picked.isEmpty ? null : picked.single.path;
    if (path == null || !context.mounted) return;
    final BackupData data;
    try {
      data = backupFromJson(await File(path).readAsString());
    } on FormatException catch (e) {
      if (context.mounted) _toast(context, 'Cannot import: ${e.message}');
      return;
    }
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace all data?'),
        content: Text(
          'This replaces everything in the app with the backup: '
          '${data.sleepSessions.length} sleep entries and ${data.expenses.length} expenses. '
          'Receipt photos are not part of the backup.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Replace'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await service.replaceAll(data);
      if (context.mounted) _toast(context, 'Backup imported');
    } catch (e) {
      if (context.mounted) _toast(context, 'Import failed: $e');
    }
  }

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
                const SizedBox(height: 24),
                const Overline('Backup'),
                const SizedBox(height: 8),
                AuraCard(
                  child: Column(
                    children: [
                      _Row(
                        label: 'Export data (JSON + CSV)',
                        value: 'Share',
                        onTap: () => _export(context, ref),
                      ),
                      const Divider(color: Aura.rim),
                      _Row(
                        label: 'Import from JSON backup',
                        value: 'Choose file',
                        onTap: () => _import(context, ref),
                      ),
                    ],
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
