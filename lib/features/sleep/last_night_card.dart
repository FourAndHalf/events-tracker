import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/settings_repository.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
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
      return AuraCard(
        child: Row(
          children: [
            const IconBadge(icon: Icons.bedtime, color: Aura.sleep),
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
    return AuraCard(
      child: Row(
        children: [
          const IconBadge(icon: Icons.bedtime, color: Aura.sleep),
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
                      style: text.labelLarge,
                    ),
                    if (last.quality != null)
                      StatusPill(
                        label: 'Quality ${last.quality}/5',
                        color: Aura.habit,
                      ),
                  ],
                ),
                Text(
                  'Woke up at ${DateFormat.jm().format(wake)}',
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          StatusPill(
            label: hit ? 'Goal hit' : 'Missed',
            color: hit ? Aura.habit : Aura.money,
          ),
        ],
      ),
    );
  }
}
