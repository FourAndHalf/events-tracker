import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../../core/widgets/home_button.dart';
import 'sleep_logic.dart';
import 'sleep_repository.dart';
import 'sleep_toggle_card.dart';

class SleepPage extends ConsumerWidget {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions =
        ref.watch(sleepListProvider).value ?? const <SleepSession>[];
    final settings = ref.watch(settingsProvider).value;

    return Scaffold(
      appBar: AppBar(
        leading: const HomeButton(),
        title: const Text('Sleep'),
        actions: [
          IconButton(
            tooltip: 'Charts',
            onPressed: () => context.push('/sleep/charts'),
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          const SleepToggleCard(),
          const SizedBox(height: 24),
          const Overline('History'),
          const SizedBox(height: 8),
          if (sessions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Nothing logged yet.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          for (final s in sessions)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SessionTile(session: s, settings: settings),
            ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session, required this.settings});

  final SleepSession session;
  final Setting? settings;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final wake = session.wakeAt;
    final timeFmt = DateFormat.jm();

    Widget badge;
    String title;
    if (wake == null) {
      title = 'In progress';
      badge = const StatusPill(label: 'Sleeping', color: Aura.sleep);
    } else {
      title = formatDuration(sleepDuration(session.sleepAt, wake));
      final hit =
          settings != null &&
          hitGoal(
            sleepAt: session.sleepAt,
            wakeAt: wake,
            goalMinutes: settings!.sleepGoalMinutes,
            targetBedtimeMinutes: settings!.targetBedtimeMinutes,
          );
      badge = StatusPill(
        label: hit ? 'Hit' : 'Miss',
        color: hit ? Aura.habit : Aura.money,
      );
    }

    return AuraCard(
      onTap: () => context.push('/sleep/edit/${session.id}'),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEE, d MMM').format(session.sleepAt),
                  style: text.bodySmall,
                ),
                const SizedBox(height: 2),
                Text(title, style: text.titleMedium),
                Text(
                  '${timeFmt.format(session.sleepAt)} → ${wake == null ? '…' : timeFmt.format(wake)}'
                  '${session.quality == null ? '' : '  ·  Quality ${session.quality}/5'}',
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          badge,
        ],
      ),
    );
  }
}
