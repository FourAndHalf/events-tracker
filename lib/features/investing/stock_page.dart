import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'invest_format.dart';
import 'investing_repository.dart';
import 'portfolio_provider.dart';

class StockPage extends ConsumerWidget {
  const StockPage({super.key, required this.stockId});

  final int stockId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holding = ref.watch(portfolioProvider).holdingFor(stockId);
    final trades = (ref.watch(tradesProvider).value ?? const <Trade>[])
        .where((t) => t.stockId == stockId)
        .toList();
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? '₹';
    final text = Theme.of(context).textTheme;
    final date = DateFormat('d MMM y');

    if (holding == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }
    final pos = holding.position;
    final fifo = holding.fifo;
    final pl = pos.unrealizedCents;

    return Scaffold(
      appBar: AppBar(title: Text(holding.stock.symbol)),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          AuraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(holding.stock.name, style: text.bodySmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pos.valueCents == null
                            ? '–'
                            : formatMoney(pos.valueCents!, sym),
                        style: text.displaySmall,
                      ),
                    ),
                    if (pl != null)
                      Text(
                        '${formatSigned(pl, sym)} (${formatPercent(pos.unrealizedPercent)})',
                        style: text.labelLarge?.copyWith(color: plColor(pl)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 20,
                  runSpacing: 4,
                  children: [
                    Text('Qty ${pos.quantity}', style: text.labelMedium),
                    Text(
                      'Avg cost ${formatMoney(pos.avgCostCents, sym)}',
                      style: text.labelMedium,
                    ),
                    Text(
                      pos.lastPriceCents == null
                          ? 'No price yet'
                          : 'Last ${formatMoney(pos.lastPriceCents!, sym)}'
                                '${holding.stock.priceDate == null ? '' : ' · ${date.format(holding.stock.priceDate!)}'}',
                      style: text.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Realized P/L ${formatSigned(fifo.realizedCents, sym)}',
                  style: text.labelMedium?.copyWith(
                    color: plColor(fifo.realizedCents),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: PillButton(
                        label: 'Buy',
                        color: Aura.invest,
                        onPressed: () =>
                            context.push('/invest/trade?stock=$stockId'),
                      ),
                    ),
                    Expanded(
                      child: PillButton(
                        label: 'Sell',
                        ghost: true,
                        onPressed: pos.isOpen
                            ? () => context.push(
                                '/invest/trade?stock=$stockId&sell=1',
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Overline('Open lots (oldest sold first)'),
          const SizedBox(height: 8),
          if (fifo.openLots.isEmpty)
            Text('No open shares.', style: text.bodySmall),
          for (final l in fifo.openLots)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AuraCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l.quantity} shares · bought ${date.format(l.buyDate)}',
                        style: text.labelLarge,
                      ),
                    ),
                    Text(
                      formatMoney(l.costCents, sym),
                      style: text.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          const Overline('Closed sales'),
          const SizedBox(height: 8),
          if (fifo.matches.isEmpty)
            Text('Nothing sold yet.', style: text.bodySmall),
          for (final m in fifo.matches)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AuraCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${m.quantity} sold ${date.format(m.sellDate)}',
                            style: text.labelLarge,
                          ),
                          Text(
                            'Bought ${date.format(m.buyDate)} · held ${formatDays(m.daysHeld)}',
                            style: text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatSigned(m.profitCents, sym),
                          style: text.labelLarge?.copyWith(
                            color: plColor(m.profitCents),
                          ),
                        ),
                        Text(
                          m.isLongTerm ? 'Long-term' : 'Short-term',
                          style: text.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          const Overline('Trade history'),
          const SizedBox(height: 8),
          for (final t in trades)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AuraCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                onTap: () => context.push('/invest/trade/${t.id}'),
                child: Row(
                  children: [
                    StatusPill(
                      label: t.isBuy ? 'Buy' : 'Sell',
                      color: t.isBuy ? Aura.invest : Aura.money,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${t.quantity} @ ${formatMoney(t.priceCents, sym)}',
                        style: text.labelLarge,
                      ),
                    ),
                    Text(date.format(t.date), style: text.bodySmall),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
