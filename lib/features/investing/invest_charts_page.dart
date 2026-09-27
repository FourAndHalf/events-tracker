import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/charts/series.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../../core/widgets/charts.dart';
import 'invest_charts.dart';
import 'investing_repository.dart';
import 'portfolio_provider.dart';

/// Portfolio value by week, realized profit per week and allocation by stock.
class InvestChartsPage extends ConsumerWidget {
  const InvestChartsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(portfolioProvider);
    final snapshots = ref.watch(snapshotsProvider).value ?? const [];
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? r'$';
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    final weeks = lastWeeks(12, now);
    final snaps = snapshotsForWeeks(snapshots, weeks);
    final realized = realizedPerWeek(portfolio, weeks);
    final alloc = allocation(portfolio);
    String money(double v) => formatMoney(v.round(), sym);
    String label(DateTime d) => DateFormat('d MMM').format(d);

    return Scaffold(
      appBar: AppBar(title: const Text('Investing charts')),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          ChartCard(
            title: 'Portfolio value by week',
            color: Aura.invest,
            subtitle:
                'Value (blue) against amount invested (grey), last 12 weeks',
            child: snaps.length < 2
                ? Text(
                    'The chart appears once two weeks of the app being opened have been recorded.',
                    style: text.bodySmall,
                  )
                : LineChart(
                    points: [
                      for (final s in snaps)
                        ChartPoint(label(s.weekStart), s.valueCents.toDouble()),
                    ],
                    secondary: [
                      for (final s in snaps)
                        ChartPoint(
                          label(s.weekStart),
                          s.investedCents.toDouble(),
                        ),
                    ],
                    formatValue: money,
                    semanticsLabel: 'Portfolio value by week',
                  ),
          ),
          const SizedBox(height: 12),
          ChartCard(
            title: 'Realized profit / loss per week',
            color: Aura.invest,
            subtitle: 'Last 12 weeks',
            child: BarChart(
              bars: [
                for (var i = 0; i < weeks.length; i++)
                  ChartBar(
                    i % 3 == 0 ? label(weeks[i]) : '',
                    realized[i].abs() / 100,
                    color: realized[i] >= 0 ? Aura.gain : Aura.loss,
                  ),
              ],
              semanticsLabel: 'Realized profit or loss per week',
            ),
          ),
          const SizedBox(height: 12),
          ChartCard(
            title: 'Allocation',
            color: Aura.invest,
            subtitle: 'Share of portfolio value by stock',
            child: alloc.isEmpty
                ? Text('No shares held.', style: text.bodySmall)
                : Column(
                    children: [
                      for (final a in alloc)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(a.symbol)),
                                  Text(
                                    '${formatMoney(a.valueCents, sym)} · ${a.percent.toStringAsFixed(1)}%',
                                    style: text.labelMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              AuraProgressBar(
                                value: a.percent / 100,
                                color: Aura.invest,
                              ),
                            ],
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
