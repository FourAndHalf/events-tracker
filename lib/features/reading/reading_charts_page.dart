import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/charts/series.dart';
import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/charts.dart';
import 'book_progress.dart';
import 'reading_repository.dart';
import 'reading_stats.dart' hide dayOf;

/// Reading time and pages over the last week or month.
class ReadingChartsPage extends ConsumerStatefulWidget {
  const ReadingChartsPage({super.key});

  @override
  ConsumerState<ReadingChartsPage> createState() => _ReadingChartsPageState();
}

class _ReadingChartsPageState extends ConsumerState<ReadingChartsPage> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final sessions =
        ref.watch(readingSessionsProvider).value ?? const <ReadingSession>[];
    final now = DateTime.now();
    final stats = sessionStats(sessions, now);
    final days = lastDays(_days, now);
    final time = timePerDay(stats);
    final pages = pagesPerDay(stats);
    final minutes = [
      for (final d in days) (time[d]?.inMinutes ?? 0).toDouble(),
    ];
    final pageValues = [for (final d in days) (pages[d] ?? 0).toDouble()];
    final totalMin = minutes.fold<double>(0, (a, b) => a + b).round();
    final totalPages = pageValues.fold<double>(0, (a, b) => a + b).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Reading charts')),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RangeToggle(
              days: _days,
              onChanged: (v) => setState(() => _days = v),
            ),
          ),
          const SizedBox(height: 16),
          ChartCard(
            title: 'Minutes read',
            color: Aura.reading,
            subtitle: '$totalMin min in the last $_days days',
            child: BarChart(
              bars: [
                for (var i = 0; i < days.length; i++)
                  ChartBar(dayLabel(days[i], _days), minutes[i]),
              ],
              color: Aura.reading,
              formatValue: (v) => v.round().toString(),
              semanticsLabel: 'Minutes read per day',
            ),
          ),
          const SizedBox(height: 12),
          ChartCard(
            title: 'Pages read',
            color: Aura.reading,
            subtitle: '$totalPages pages in the last $_days days',
            child: BarChart(
              bars: [
                for (var i = 0; i < days.length; i++)
                  ChartBar(dayLabel(days[i], _days), pageValues[i]),
              ],
              color: Aura.reading,
              formatValue: (v) => v.round().toString(),
              semanticsLabel: 'Pages read per day',
            ),
          ),
        ],
      ),
    );
  }
}
