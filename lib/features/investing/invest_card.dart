import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'invest_format.dart';
import 'investing_repository.dart';
import 'portfolio.dart';
import 'portfolio_provider.dart';
import 'weekly_report.dart';

/// Dashboard card: portfolio value, unrealized P/L, this week's realized P/L
/// and a prompt when prices are old.
class InvestCard extends ConsumerWidget {
  const InvestCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(portfolioProvider);
    final stocks = ref.watch(stocksProvider).value ?? const <Stock>[];
    final trades = ref.watch(tradesProvider).value ?? const <Trade>[];
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? r'$';
    final text = Theme.of(context).textTheme;
    final today = DateTime.now();

    if (trades.isEmpty) {
      return AuraCard(
        onTap: () => context.go('/invest'),
        child: Row(
          children: [
            const IconBadge(icon: Icons.show_chart, color: Aura.invest),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Investing: record your first trade',
                style: text.bodyMedium,
              ),
            ),
            const Icon(Icons.chevron_right, color: Aura.textSecondary),
          ],
        ),
      );
    }

    final week = buildWeeklyReport(
      weekStart: weekStartOf(today),
      stocks: stocks,
      trades: trades,
      snapshots: const [],
      today: today,
      liveValueCents: p.valueCents,
    );

    // Oldest price among the shares you hold (null age = no price at all).
    final held = p.open.map((h) => h.stock).toList();
    final stale = held.where((s) => isPriceStale(s, today)).toList();
    final ages = held.map((s) => priceAgeDays(s, today));
    final oldest = ages.contains(null)
        ? null
        : (ages.isEmpty
              ? 0
              : ages.whereType<int>().reduce((a, b) => a > b ? a : b));

    return AuraCard(
      onTap: () => context.go('/invest'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Overline('Investing', color: Aura.invest)),
              const Icon(Icons.chevron_right, color: Aura.textSecondary),
            ],
          ),
          const SizedBox(height: 8),
          Text(formatMoney(p.valueCents, sym), style: text.displaySmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Unrealized ', style: text.bodySmall),
                    TextSpan(
                      text: formatSigned(p.unrealizedCents, sym),
                      style: text.labelMedium?.copyWith(
                        color: plColor(p.unrealizedCents),
                      ),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'This week ', style: text.bodySmall),
                    TextSpan(
                      text: formatSigned(week.realizedCents, sym),
                      style: text.labelMedium?.copyWith(
                        color: plColor(week.realizedCents),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (stale.isNotEmpty) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => context.push('/invest/prices'),
              child: StatusPill(
                label: oldest == null
                    ? 'Prices missing · tap to update'
                    : 'Prices are $oldest days old · tap to update',
                color: Aura.money,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
