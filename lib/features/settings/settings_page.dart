import 'package:drift/drift.dart' show Value;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/db/providers.dart';
import '../../core/db/settings_repository.dart';
import '../../core/notifications/report_notifier.dart';
import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../memories/media_logic.dart';
import '../memories/media_storage.dart';
import '../memories/memories_repository.dart';
import 'backup_codec.dart';
import 'backup_zip.dart';
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

  Future<void> _exportZip(BuildContext context, WidgetRef ref) async {
    try {
      final data = await ref.read(backupServiceProvider).readAll();
      final sizes = mediaSizes(data.memoryMedia);
      if (!context.mounted) return;
      var includeVideos = true;
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: const Text('Full backup'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'One .zip with your data and memory photos (${formatBytes(sizes.photos)}).',
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Include videos'),
                  subtitle: Text(formatBytes(sizes.videos)),
                  value: includeVideos,
                  onChanged: (v) => setState(() => includeVideos = v),
                ),
                Text(
                  'Total about ${formatBytes(sizes.photos + (includeVideos ? sizes.videos : 0))}.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      );
      if (ok != true) return;
      final stamp = DateTime.now().toIso8601String().substring(0, 10);
      final dir = await Directory(
        p.join((await getTemporaryDirectory()).path, 'export'),
      ).create(recursive: true);
      final zip = await writeBackupZip(
        data,
        p.join(dir.path, 'tracker-full-backup-$stamp.zip'),
        includeVideos: includeVideos,
      );
      await SharePlus.instance.share(
        ShareParams(files: [XFile(zip.path)], subject: 'Tracker backup $stamp'),
      );
    } catch (e) {
      if (context.mounted) _toast(context, 'Export failed: $e');
    }
  }

  Future<void> _importZip(
    BuildContext context,
    WidgetRef ref,
    String path,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace all data?'),
        content: const Text(
          'This replaces everything in the app with the full backup, '
          'including memory photos and videos.',
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
      await importBackupZip(
        zip: File(path),
        service: ref.read(backupServiceProvider),
        tmp: Directory(p.join((await getTemporaryDirectory()).path, 'unpack')),
        mediaRoot: await memoriesRoot(),
      );
      if (context.mounted) _toast(context, 'Backup imported');
    } on FormatException catch (e) {
      if (context.mounted) _toast(context, 'Cannot import: ${e.message}');
    } catch (e) {
      if (context.mounted) _toast(context, 'Import failed: $e');
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final service = ref.read(backupServiceProvider);
    final picked = await FilePicker.pickFiles(type: FileType.any);
    final path = picked.isEmpty ? null : picked.single.path;
    if (path == null || !context.mounted) return;
    if (path.toLowerCase().endsWith('.zip')) {
      return _importZip(context, ref, path);
    }
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
          '${data.sleepSessions.length} sleep entries, ${data.expenses.length} expenses and ${data.trades.length} trades. '
          'Receipt photos and memory photos/videos are only in a full .zip backup.',
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
                const Overline('Reminders'),
                const SizedBox(height: 8),
                AuraCard(
                  child: _Row(
                    label: 'Bedtime, expenses, trackers',
                    value: 'Manage',
                    onTap: () => context.push('/settings/reminders'),
                  ),
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
                const Overline('Memories'),
                const SizedBox(height: 8),
                AuraCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Photos and videos stored',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Text(
                            formatBytes(
                              totalMediaBytes(
                                ref.watch(memoryMediaProvider).value ??
                                    const [],
                              ),
                            ),
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: Aura.memory),
                          ),
                        ],
                      ),
                      const Divider(color: Aura.rim),
                      _Row(
                        label: 'Reminder time',
                        value: TimeOfDay(
                          hour: s.memoryRemindMinutes ~/ 60,
                          minute: s.memoryRemindMinutes % 60,
                        ).format(context),
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: s.memoryRemindMinutes ~/ 60,
                              minute: s.memoryRemindMinutes % 60,
                            ),
                          );
                          if (t == null) return;
                          await updateSettings(
                            db,
                            SettingsCompanion(
                              memoryRemindMinutes: Value(
                                t.hour * 60 + t.minute,
                              ),
                            ),
                          );
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('"On this day" notification'),
                        subtitle: const Text(
                          'A morning nudge when an old memory matches today',
                        ),
                        value: s.onThisDayEnabled,
                        onChanged: (v) async {
                          if (v) {
                            await ref
                                .read(reportNotifierProvider)
                                .requestPermission();
                          }
                          await updateSettings(
                            db,
                            SettingsCompanion(onThisDayEnabled: Value(v)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Overline('Investing'),
                const SizedBox(height: 8),
                AuraCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Sunday weekly report'),
                        subtitle: const Text(
                          'A notification with your week in numbers',
                        ),
                        value: s.weeklyReportEnabled,
                        onChanged: (v) async {
                          if (v) {
                            await ref
                                .read(reportNotifierProvider)
                                .requestPermission();
                          }
                          await updateSettings(
                            db,
                            SettingsCompanion(weeklyReportEnabled: Value(v)),
                          );
                        },
                      ),
                      if (s.weeklyReportEnabled) ...[
                        const Divider(color: Aura.rim),
                        _Row(
                          label: 'Notification time (Sunday)',
                          value: TimeOfDay(
                            hour: s.weeklyReportMinutes ~/ 60,
                            minute: s.weeklyReportMinutes % 60,
                          ).format(context),
                          onTap: () async {
                            final t = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: s.weeklyReportMinutes ~/ 60,
                                minute: s.weeklyReportMinutes % 60,
                              ),
                            );
                            if (t == null) return;
                            await updateSettings(
                              db,
                              SettingsCompanion(
                                weeklyReportMinutes: Value(
                                  t.hour * 60 + t.minute,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
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
                        label: 'Full backup with photos (.zip)',
                        value: 'Share',
                        onTap: () => _exportZip(context, ref),
                      ),
                      const Divider(color: Aura.rim),
                      _Row(
                        label: 'Import backup (JSON or .zip)',
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
