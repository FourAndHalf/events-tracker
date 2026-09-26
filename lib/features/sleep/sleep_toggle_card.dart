import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'sleep_repository.dart';
import 'wake_prompt.dart';

/// Big one-tap "Going to sleep" / "I'm awake" card.
class SleepToggleCard extends ConsumerWidget {
  const SleepToggleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.watch(openSleepProvider).value;
    final repo = ref.read(sleepRepositoryProvider);
    final asleep = open != null;

    Future<void> onTap() async {
      if (!asleep) {
        await repo.start(DateTime.now());
        return;
      }
      await repo.wake(open.id, DateTime.now());
      if (!context.mounted) return;
      final answer = await showWakePrompt(context);
      if (answer != null) {
        await repo.setQuality(open.id, answer.quality, answer.note);
      }
    }

    return AuraCard(
      borderColor: asleep ? Aura.sleep.withValues(alpha: 0.5) : Aura.rim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Overline(asleep ? 'Sleeping' : 'Rest & sleep', color: Aura.sleep),
          const SizedBox(height: 8),
          Text(
            asleep
                ? 'Since ${DateFormat.jm().format(open.sleepAt)}'
                : 'Ready for bed?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PillButton(
              label: asleep ? "I'm awake" : 'Going to sleep',
              icon: asleep ? Icons.wb_sunny_outlined : Icons.bedtime,
              onPressed: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
