import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/pearl_widgets.dart';
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
      return Module(
        onTap: () => context.push('/trackers'),
        child: Row(
          children: [
            const IconChip(icon: Icons.checklist),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Trackers: add a habit or a timer',
                style: text.bodyMedium,
              ),
            ),
            Icon(Icons.chevron_right, color: context.pearl.muted),
          ],
        ),
      );
    }

    return Module(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModuleHeader(
            title: 'Trackers',
            subtitle: 'Today',
            trailing: PillButton(
              label: 'View all',
              variant: PillVariant.secondary,
              onPressed: () => context.push('/trackers'),
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
                      IconChip(icon: trackerIcon(t.icon)),
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
