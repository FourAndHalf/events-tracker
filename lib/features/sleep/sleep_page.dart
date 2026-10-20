import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/pearl_widgets.dart';
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
          PearlIconButton(
            tooltip: 'Charts',
            onPressed: () => context.push('/sleep/charts'),
            icon: Icons.bar_chart,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Pearl.margin),
        children: [
          const SleepToggleCard(),
          const SizedBox(height: Pearl.spaceLg),
          const SectionTitle('History'),
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
              padding: const EdgeInsets.only(bottom: Pearl.gutter),
              child: _SessionTile(
                session: s,
                settings: settings,
                onDelete: () => _confirmDelete(context, ref, s),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  SleepSession s,
) async {
  final ok = await confirmAction(context, title: 'Delete this night?');
  if (ok) await ref.read(sleepRepositoryProvider).delete(s.id);
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.session,
    required this.settings,
    required this.onDelete,
  });

  final SleepSession session;
  final Setting? settings;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final wake = session.wakeAt;
    final timeFmt = DateFormat.jm();

    Widget badge;
    String title;
    if (wake == null) {
      title = 'In progress';
      badge = const StatusBadge(label: 'Sleeping', tone: BadgeTone.dark);
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
      badge = StatusBadge(
        label: hit ? 'Hit' : 'Miss',
        tone: hit ? BadgeTone.positive : BadgeTone.warning,
      );
    }

    return Module(
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
                Text(title, style: PearlType.metricCard),
                Text(
                  '${timeFmt.format(session.sleepAt)} → ${wake == null ? '…' : timeFmt.format(wake)}'
                  '${session.quality == null ? '' : '  ·  Quality ${session.quality}/5'}',
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          badge,
          IconButton(
            tooltip: 'Delete',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
