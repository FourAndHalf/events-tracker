import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../../core/widgets/elapsed_text.dart';
import '../sleep/sleep_logic.dart';
import 'tracker_icons.dart';
import 'tracker_logic.dart';
import 'trackers_page.dart';
import 'trackers_repository.dart';

/// Dashboard card: quick check-offs and start/stop buttons for every tracker,
/// with running timers ticking.
class TrackerCard extends ConsumerWidget {
  const TrackerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackers = (ref.watch(trackersProvider).value ?? const <Tracker>[])
        .where((t) => !t.archived)
        .toList();
    final entries =
        ref.watch(trackerEntriesProvider).value ?? const <TrackerEntry>[];
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();

    if (trackers.isEmpty) {
      return AuraCard(
        onTap: () => context.push('/trackers'),
        child: Row(
          children: [
            const IconBadge(icon: Icons.checklist, color: Aura.habit),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Trackers: add a habit or a timer',
                style: text.bodyMedium,
              ),
            ),
            const Icon(Icons.chevron_right, color: Aura.textSecondary),
          ],
        ),
      );
    }

    return AuraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push('/trackers'),
            child: const Row(
              children: [
                Expanded(child: Overline('Trackers', color: Aura.habit)),
                Icon(Icons.chevron_right, color: Aura.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 8),
          for (final t in trackers)
            Builder(
              builder: (context) {
                final s = trackerToday(t, entries, now);
                final isTimer = t.type == TrackerType.duration.name;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(trackerIcon(t.icon), color: Aura.habit),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.name, style: text.titleSmall),
                            if (isTimer && s.running != null)
                              ElapsedText(
                                start: s.running!.startAt!,
                                style: text.bodySmall,
                              )
                            else
                              Text(
                                isTimer
                                    ? 'Today ${formatDuration(s.today)}'
                                    : (s.streak > 0
                                          ? '${s.streak} day streak'
                                          : 'Not yet today'),
                                style: text.bodySmall,
                              ),
                          ],
                        ),
                      ),
                      TrackerAction(tracker: t, state: s),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
