import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/charts/series.dart';
import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/charts.dart';
import 'sleep_charts.dart';
import 'sleep_repository.dart';

/// Hours slept and bedtime consistency over the last week or month.
class SleepChartsPage extends ConsumerStatefulWidget {
  const SleepChartsPage({super.key});

  @override
  ConsumerState<SleepChartsPage> createState() => _SleepChartsPageState();
}

class _SleepChartsPageState extends ConsumerState<SleepChartsPage> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final sessions =
        ref.watch(sleepListProvider).value ?? const <SleepSession>[];
    final settings = ref.watch(settingsProvider).value;
    final goalHours = (settings?.sleepGoalMinutes ?? 480) / 60;
    final days = lastDays(_days, DateTime.now());
    final hours = sleepHoursPerDay(sessions, days);
    final bedtimes = bedtimesIn(sessions, days);
    final consistency = bedtimeConsistency([
      for (final b in bedtimes) b.minutes,
    ]);
    final nights = hours.where((h) => h > 0).length;
    final avg = nights == 0 ? 0.0 : hours.reduce((a, b) => a + b) / nights;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sleep charts')),
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
            title: 'Hours slept',
            color: Aura.sleep,
            subtitle: nights == 0
                ? 'No nights logged in this range'
                : 'Average ${avg.toStringAsFixed(1)} h over $nights nights · goal ${goalHours.toStringAsFixed(1)} h',
            child: BarChart(
              bars: [
                for (var i = 0; i < days.length; i++)
                  ChartBar(
                    dayLabel(days[i], _days),
                    hours[i],
                    color: hours[i] >= goalHours ? Aura.gain : Aura.sleep,
                  ),
              ],
              goal: goalHours,
              formatValue: (v) => v.toStringAsFixed(1),
              semanticsLabel: 'Hours slept per day',
            ),
          ),
          const SizedBox(height: 12),
          ChartCard(
            title: 'Bedtime consistency',
            color: Aura.sleep,
            subtitle: consistency == null
                ? 'No nights logged in this range'
                : 'Average ${clockOf(consistency.average)} · varies by about ${consistency.spread.round()} min'
                      '${bedtimes.length < 3 ? ' (needs a few nights to mean much)' : ''}',
            child: bedtimes.length < 2
                ? Text(
                    'Log at least two nights to see the trend.',
                    style: text.bodySmall,
                  )
                : LineChart(
                    points: [
                      for (final b in bedtimes)
                        ChartPoint(
                          '${b.day.day}/${b.day.month}',
                          b.minutes.toDouble(),
                        ),
                    ],
                    color: Aura.sleep,
                    formatValue: clockOf,
                    semanticsLabel: 'Bedtime per night',
                  ),
          ),
        ],
      ),
    );
  }
}
