import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/settings_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/pearl_widgets.dart';
import 'sleep_logic.dart';
import 'sleep_repository.dart';

/// Dashboard card: last completed night, quality and hit/miss.
class LastNightCard extends ConsumerWidget {
  const LastNightCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final last = ref.watch(lastSleepProvider).value;
    final settings = ref.watch(settingsProvider).value;
    final text = Theme.of(context).textTheme;

    if (last == null || settings == null) {
      return Module(
        child: Row(
          children: [
            const IconChip(icon: Icons.bedtime_outlined),
            const SizedBox(width: 12),
            Text('No sleep logged yet', style: text.bodyMedium),
          ],
        ),
      );
    }

    final wake = last.wakeAt!;
    final dur = sleepDuration(last.sleepAt, wake);
    final hit = hitGoal(
      sleepAt: last.sleepAt,
      wakeAt: wake,
      goalMinutes: settings.sleepGoalMinutes,
      targetBedtimeMinutes: settings.targetBedtimeMinutes,
    );
    return Module(
      child: Row(
        children: [
          const IconChip(icon: Icons.bedtime_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${formatDuration(dur)} sleep',
                      style: PearlType.metricTable,
                    ),
                    if (last.quality != null)
                      StatusBadge(label: 'Quality ${last.quality}/5'),
                  ],
                ),
                Text(
                  'Woke up at ${DateFormat.jm().format(wake)}',
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          StatusBadge(
            label: hit ? 'Goal hit' : 'Missed',
            tone: hit ? BadgeTone.positive : BadgeTone.warning,
          ),
        ],
      ),
    );
  }
}
