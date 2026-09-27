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
import 'trackers_repository.dart';

/// Today's state for one tracker, shared by the page and the dashboard card.
class TrackerToday {
  const TrackerToday({
    required this.done,
    required this.streak,
    required this.today,
    this.running,
  });

  /// Habit: checked today.
  final bool done;

  /// Habit: current streak in days. Duration: number of days with any time.
  final int streak;

  /// Duration: total time today, running timer included.
  final Duration today;
  final TrackerEntry? running;
}

TrackerToday trackerToday(
  Tracker t,
  Iterable<TrackerEntry> entries,
  DateTime now,
) {
  final mine = entries.where((e) => e.trackerId == t.id).toList();
  final todayDay = dayOf(now);
  final duration = t.type == TrackerType.duration.name;
  final running = mine
      .where((e) => e.startAt != null && e.endAt == null)
      .firstOrNull;
  var total = Duration.zero;
  if (duration) {
    for (final e in mine.where(
      (e) => e.startAt != null && dayOf(e.day) == todayDay,
    )) {
      total += entryDuration(e.startAt!, e.endAt, now);
    }
  }
  return TrackerToday(
    done: !duration && mine.any((e) => dayOf(e.day) == todayDay),
    streak: currentStreak(mine.map((e) => e.day), now),
    today: total,
    running: running,
  );
}

/// The start/stop or check button for a tracker.
class TrackerAction extends ConsumerWidget {
  const TrackerAction({super.key, required this.tracker, required this.state});

  final Tracker tracker;
  final TrackerToday state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(trackersRepositoryProvider);
    if (tracker.type == TrackerType.duration.name) {
      final running = state.running != null;
      return IconButton.filled(
        tooltip: running ? 'Stop ${tracker.name}' : 'Start ${tracker.name}',
        style: IconButton.styleFrom(
          backgroundColor: running ? Aura.habit : Aura.raised,
          foregroundColor: running ? Aura.canvas : Aura.text,
        ),
        onPressed: () => running
            ? repo.stopTimer(tracker.id, DateTime.now())
            : repo.startTimer(tracker.id, DateTime.now()),
        icon: Icon(running ? Icons.stop : Icons.play_arrow),
      );
    }
    return IconButton.filled(
      tooltip: state.done
          ? 'Uncheck ${tracker.name}'
          : 'Check off ${tracker.name}',
      style: IconButton.styleFrom(
        backgroundColor: state.done ? Aura.habit : Aura.raised,
        foregroundColor: state.done ? Aura.canvas : Aura.text,
      ),
      onPressed: () => repo.toggleHabit(tracker.id, DateTime.now()),
      icon: const Icon(Icons.check),
    );
  }
}

class TrackersPage extends ConsumerWidget {
  const TrackersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackers = (ref.watch(trackersProvider).value ?? const <Tracker>[])
        .where((t) => !t.archived)
        .toList();
    final entries =
        ref.watch(trackerEntriesProvider).value ?? const <TrackerEntry>[];
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Trackers')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/trackers/add'),
        backgroundColor: Aura.habit,
        foregroundColor: Aura.canvas,
        icon: const Icon(Icons.add),
        label: const Text('Tracker'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Aura.margin,
          Aura.margin,
          Aura.margin,
          96,
        ),
        children: [
          if (trackers.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'Track anything: a daily habit or time spent on something.',
                  textAlign: TextAlign.center,
                  style: text.bodySmall,
                ),
              ),
            ),
          for (final t in trackers) ...[
            Builder(
              builder: (context) {
                final s = trackerToday(t, entries, now);
                final isTimer = t.type == TrackerType.duration.name;
                return AuraCard(
                  onTap: () => context.push('/trackers/${t.id}'),
                  child: Row(
                    children: [
                      IconBadge(icon: trackerIcon(t.icon), color: Aura.habit),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.name, style: text.titleMedium),
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
                                          : 'No streak yet'),
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
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
