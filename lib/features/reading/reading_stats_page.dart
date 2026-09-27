import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../sleep/sleep_logic.dart';
import 'book_progress.dart';
import 'reading_repository.dart';
import 'reading_stats.dart';

/// Reading time per day and week, pages per day, and the streak.
class ReadingStatsPage extends ConsumerWidget {
  const ReadingStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions =
        ref.watch(readingSessionsProvider).value ?? const <ReadingSession>[];
    final now = DateTime.now();
    final stats = sessionStats(sessions, now);
    final perDay = timePerDay(stats);
    final perWeek = timePerWeek(stats);
    final pages = pagesPerDay(stats);
    final text = Theme.of(context).textTheme;

    final today = dayOf(now);
    final days = [
      for (var i = 6; i >= 0; i--)
        DateTime(today.year, today.month, today.day - i),
    ];
    final maxMinutes = days
        .map((d) => perDay[d]?.inMinutes ?? 0)
        .fold<int>(0, (a, b) => a > b ? a : b);
    final thisWeek = weekOf(now);
    final weeks = [
      for (var i = 0; i < 4; i++)
        DateTime(thisWeek.year, thisWeek.month, thisWeek.day - 7 * i),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Reading stats')),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          AuraCard(
            child: Row(
              children: [
                Expanded(
                  child: _Stat(
                    label: 'Streak',
                    value: '${readingStreak(stats, now)} days',
                  ),
                ),
                Expanded(
                  child: _Stat(
                    label: 'This week',
                    value: formatDuration(perWeek[thisWeek] ?? Duration.zero),
                  ),
                ),
                Expanded(
                  child: _Stat(
                    label: 'Pages today',
                    value: '${pages[today] ?? 0}',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AuraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Overline('Last 7 days', color: Aura.reading),
                const SizedBox(height: 12),
                for (final d in days)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 44,
                          child: Text(
                            DateFormat('EEE').format(d),
                            style: text.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: AuraProgressBar(
                            value: maxMinutes == 0
                                ? 0
                                : (perDay[d]?.inMinutes ?? 0) / maxMinutes,
                            color: Aura.reading,
                          ),
                        ),
                        SizedBox(
                          width: 92,
                          child: Text(
                            '${formatDuration(perDay[d] ?? Duration.zero)}'
                            ' · ${pages[d] ?? 0}p',
                            textAlign: TextAlign.end,
                            style: text.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AuraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Overline('Weeks', color: Aura.reading),
                const SizedBox(height: 8),
                for (final w in weeks)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text('Week of ${DateFormat('d MMM').format(w)}'),
                    trailing: Text(
                      formatDuration(perWeek[w] ?? Duration.zero),
                      style: text.labelLarge,
                    ),
                  ),
              ],
            ),
          ),
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
        const SizedBox(height: 2),
        Text(label, style: text.bodySmall),
      ],
    );
  }
}
