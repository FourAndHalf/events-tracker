import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../../core/widgets/home_button.dart';
import 'invest_format.dart';
import 'investing_repository.dart';
import 'portfolio_provider.dart';
import 'weekly_report.dart';

class WeeklyPage extends ConsumerStatefulWidget {
  const WeeklyPage({super.key});

  @override
  ConsumerState<WeeklyPage> createState() => _WeeklyPageState();
}

class _WeeklyPageState extends ConsumerState<WeeklyPage> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final stocks = ref.watch(stocksProvider).value ?? const <Stock>[];
    final trades = ref.watch(tradesProvider).value ?? const <Trade>[];
    final snaps =
        ref.watch(snapshotsProvider).value ?? const <WeeklySnapshot>[];
    final live = ref.watch(portfolioProvider).valueCents;
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? r'$';
    final today = DateTime.now();
    final text = Theme.of(context).textTheme;
    final weeks = reportWeeks(trades, snaps, today);
    final selected = _selected ?? weekStartOf(today);

    WeeklyReport report(DateTime w) => buildWeeklyReport(
      weekStart: w,
      stocks: stocks,
      trades: trades,
      snapshots: snaps,
      today: today,
      liveValueCents: live,
    );

    final r = report(selected);
    final range = _range(selected);

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? null : const HomeButton(),
        title: const Text('Weekly report'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          Overline(
            selected == weekStartOf(today) ? 'This week · $range' : range,
          ),
          const SizedBox(height: 8),
          AuraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Overline('Portfolio value', color: Aura.invest),
                const SizedBox(height: 4),
                Text(
                  r.valueCents == null
                      ? 'Not recorded'
                      : formatMoney(r.valueCents!, sym),
                  style: text.displaySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  r.valueChangeCents == null
                      ? 'No earlier week to compare with'
                      : '${formatSigned(r.valueChangeCents!, sym)} vs last week',
                  style: text.labelMedium?.copyWith(
                    color: plColor(r.valueChangeCents),
                  ),
                ),
                const SizedBox(height: 4),
                Text('As of the last price update', style: text.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Trades',
            rows: [
              _Row('Buys', '${r.buyCount}'),
              _Row('Sells', '${r.sellCount}'),
              _Row('Money invested', formatMoney(r.boughtCents, sym)),
              _Row('Money taken out', formatMoney(r.soldCents, sym)),
            ],
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Realized profit / loss',
            rows: [
              _Row(
                'This week',
                formatSigned(r.realizedCents, sym),
                plColor(r.realizedCents),
              ),
              _Row(
                'Year to date',
                formatSigned(r.yearRealizedCents, sym),
                plColor(r.yearRealizedCents),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Closed trades',
            rows: [
              _Row(
                'Win rate',
                r.winRatePercent == null
                    ? '–'
                    : '${r.winRatePercent!.round()}% (${r.wins} of ${r.closedCount})',
              ),
              _Row(
                'Best',
                r.best == null
                    ? '–'
                    : '${r.best!.symbol} ${formatSigned(r.best!.profitCents, sym)}',
                plColor(r.best?.profitCents),
              ),
              _Row(
                'Worst',
                r.worst == null
                    ? '–'
                    : '${r.worst!.symbol} ${formatSigned(r.worst!.profitCents, sym)}',
                plColor(r.worst?.profitCents),
              ),
              _Row(
                'Average holding time',
                r.avgHoldDays == null
                    ? '–'
                    : formatDays(r.avgHoldDays!.round()),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Overline('Past weeks'),
          const SizedBox(height: 8),
          for (final w in weeks)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Builder(
                builder: (context) {
                  final wr = report(w);
                  return AuraCard(
                    borderColor: w == selected ? Aura.invest : Aura.rim,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    onTap: () => setState(() => _selected = w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_range(w), style: text.labelLarge),
                              Text(
                                '${wr.tradeCount} trade${wr.tradeCount == 1 ? '' : 's'}',
                                style: text.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formatSigned(wr.realizedCents, sym),
                          style: text.labelLarge?.copyWith(
                            color: plColor(wr.realizedCents),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _range(DateTime start) {
    final f = DateFormat('d MMM');
    return '${f.format(start)} – ${f.format(weekEndOf(start).subtract(const Duration(days: 1)))}';
  }
}

class _Row {
  const _Row(this.label, this.value, [this.color]);
  final String label;
  final String value;
  final Color? color;
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<_Row> rows;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AuraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Overline(title),
          const SizedBox(height: 8),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(child: Text(row.label, style: text.bodyMedium)),
                  Text(
                    row.value,
                    style: text.labelLarge?.copyWith(color: row.color),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
