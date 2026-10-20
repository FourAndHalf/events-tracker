import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/elapsed_text.dart';
import '../../core/widgets/pearl_widgets.dart';
import 'sleep_repository.dart';
import 'wake_prompt.dart';

/// Big one-tap "Going to sleep" / "I'm awake" card.
class SleepToggleCard extends ConsumerWidget {
  const SleepToggleCard({super.key, this.hero = false});

  /// The dashboard's hero module: xl radius and the pearl wash.
  final bool hero;

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

    final text = Theme.of(context).textTheme;
    return Module(
      large: hero,
      gradient: hero ? context.pearl.heroGradient : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  asleep ? 'Sleeping' : 'Rest and sleep',
                  style: text.titleMedium,
                ),
              ),
              if (asleep)
                const StatusBadge(label: 'In progress', tone: BadgeTone.dark),
            ],
          ),
          const SizedBox(height: Pearl.spaceSm),
          if (asleep)
            ElapsedText(start: open.sleepAt, style: text.displaySmall)
          else
            Text('Ready for bed?', style: text.headlineMedium),
          Text(
            asleep
                ? 'Since ${DateFormat.jm().format(open.sleepAt)}'
                : 'One tap when you turn in',
            style: text.bodySmall,
          ),
          const SizedBox(height: Pearl.spaceMd),
          SizedBox(
            width: double.infinity,
            child: PillButton(
              label: asleep ? "I'm awake" : 'Going to sleep',
              icon: asleep ? Icons.wb_sunny_outlined : Icons.bedtime_outlined,
              onPressed: onTap,
            ),
          ),
          if (asleep) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: context.pearl.negative,
                ),
                onPressed: () => _confirmDelete(context, ref, open.id),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Delete this sleep session'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Future<void> _confirmDelete(BuildContext context, WidgetRef ref, int id) async {
  final ok = await confirmAction(
    context,
    title: 'Delete this sleep session?',
    message: 'This will remove the active sleep session.',
  );
  if (ok) await ref.read(sleepRepositoryProvider).delete(id);
}
