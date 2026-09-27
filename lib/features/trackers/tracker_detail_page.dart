import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../sleep/sleep_logic.dart';
import 'tracker_icons.dart';
import 'tracker_logic.dart';
import 'trackers_repository.dart';

/// History and stats for one tracker.
class TrackerDetailPage extends ConsumerWidget {
  const TrackerDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = (ref.watch(trackersProvider).value ?? const <Tracker>[])
        .where((t) => t.id == id)
        .firstOrNull;
    if (t == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }
    final entries =
        (ref.watch(trackerEntriesProvider).value ?? const <TrackerEntry>[])
            .where((e) => e.trackerId == id)
            .toList();
    final repo = ref.read(trackersRepositoryProvider);
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    final today = dayOf(now);
    final isTimer = t.type == TrackerType.duration.name;
    final days = entries.map((e) => e.day).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.name),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () => context.push('/trackers/edit/${t.id}'),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete this tracker?'),
                  content: const Text('All its history is deleted too.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (ok != true) return;
              await repo.deleteTracker(t.id);
              if (context.mounted) context.pop();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          AuraCard(
            child: Row(
              children: [
                IconBadge(icon: trackerIcon(t.icon), color: Aura.habit),
                const SizedBox(width: 16),
                Expanded(
                  child: _Stat(
                    label: 'Current streak',
                    value: '${currentStreak(days, now)} days',
                  ),
                ),
                Expanded(
                  child: _Stat(
                    label: 'Best streak',
                    value: '${bestStreak(days)} days',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!isTimer) ...[
            const Overline('Last 28 days', color: Aura.habit),
            const SizedBox(height: 4),
            Text('Tap a day to fix it.', style: text.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var i = 27; i >= 0; i--)
                  Builder(
                    builder: (context) {
                      final d = DateTime(
                        today.year,
                        today.month,
                        today.day - i,
                      );
                      final done = entries.any((e) => dayOf(e.day) == d);
                      return InkWell(
                        onTap: () => repo.toggleHabit(t.id, d),
                        customBorder: const CircleBorder(),
                        child: Tooltip(
                          message: DateFormat('EEE d MMM').format(d),
                          child: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done ? Aura.habit : Aura.raised,
                            ),
                            child: Text(
                              '${d.day}',
                              style: text.labelSmall?.copyWith(
                                color: done ? Aura.canvas : Aura.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ] else ...[
            const Overline('Sessions', color: Aura.habit),
            const SizedBox(height: 4),
            if (entries.where((e) => e.startAt != null).isEmpty)
              Text('No sessions yet.', style: text.bodySmall),
            for (final e in entries.where((e) => e.startAt != null))
              Dismissible(
                key: ValueKey('entry-${e.id}'),
                direction: e.endAt == null
                    ? DismissDirection.none
                    : DismissDirection.endToStart,
                background: Container(
                  color: Aura.loss.withValues(alpha: 0.3),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete_outline),
                ),
                onDismissed: (_) => repo.deleteEntry(e.id),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    DateFormat('EEE d MMM, HH:mm').format(e.startAt!),
                  ),
                  trailing: Text(
                    e.endAt == null
                        ? 'Running'
                        : formatDuration(
                            entryDuration(e.startAt!, e.endAt, now),
                          ),
                    style: text.labelLarge,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(value, style: text.titleMedium),
        Text(label, style: text.bodySmall),
      ],
    );
  }
}
