import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../../core/widgets/home_button.dart';
import 'invest_format.dart';
import 'portfolio.dart';
import 'portfolio_provider.dart';

class PortfolioPage extends ConsumerWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(portfolioProvider);
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? '₹';
    final text = Theme.of(context).textTheme;
    final closed = p.holdings.where(
      (h) => !h.position.isOpen && h.fifo.matches.isNotEmpty,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const HomeButton(),
        title: const Text('Investing'),
        actions: [
          IconButton(
            tooltip: 'Charts',
            onPressed: () => context.push('/invest/charts'),
            icon: const Icon(Icons.bar_chart),
          ),
          IconButton(
            tooltip: 'Update prices',
            onPressed: () => context.push('/invest/prices'),
            icon: const Icon(Icons.price_change_outlined),
          ),
          IconButton(
            tooltip: 'Weekly report',
            onPressed: () => context.push('/invest/weekly'),
            icon: const Icon(Icons.insights_outlined),
          ),
          IconButton(
            tooltip: 'Trade journal',
            onPressed: () => context.push('/invest/journal'),
            icon: const Icon(Icons.receipt_long_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/invest/trade'),
        backgroundColor: Aura.invest,
        foregroundColor: Aura.canvas,
        icon: const Icon(Icons.add),
        label: const Text('Trade'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Aura.margin,
          Aura.margin,
          Aura.margin,
          96,
        ),
        children: [
          AuraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Overline('Portfolio value', color: Aura.invest),
                const SizedBox(height: 4),
                Text(formatMoney(p.valueCents, sym), style: text.displaySmall),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        'Invested',
                        formatMoney(p.investedCents, sym),
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        'Unrealized P/L',
                        formatSigned(p.unrealizedCents, sym),
                        color: plColor(p.unrealizedCents),
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        'Realized P/L',
                        formatSigned(p.realizedCents, sym),
                        color: plColor(p.realizedCents),
                      ),
                    ),
                  ],
                ),
                if (p.unpricedCount > 0) ...[
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => context.push('/invest/prices'),
                    child: StatusPill(
                      label:
                          '${p.unpricedCount} without a price · tap to update',
                      color: Aura.money,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Overline('Holdings'),
          const SizedBox(height: 8),
          if (p.open.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No shares held. Tap Trade to record a buy.',
                  style: text.bodySmall,
                ),
              ),
            ),
          for (final h in p.open)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _HoldingTile(holding: h, symbol: sym),
            ),
          if (closed.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Overline('Closed'),
            const SizedBox(height: 8),
            for (final h in closed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AuraCard(
                  onTap: () => context.push('/invest/stock/${h.stock.id}'),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(h.stock.symbol, style: text.labelLarge),
                      ),
                      Text(
                        formatSigned(h.fifo.realizedCents, sym),
                        style: text.labelLarge?.copyWith(
                          color: plColor(h.fifo.realizedCents),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, {this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.bodySmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: text.labelLarge?.copyWith(color: color),
          maxLines: 1,
        ),
      ],
    );
  }
}

class _HoldingTile extends StatelessWidget {
  const _HoldingTile({required this.holding, required this.symbol});

  final Holding holding;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final pos = holding.position;
    final pl = pos.unrealizedCents;
    return AuraCard(
      onTap: () => context.push('/invest/stock/${holding.stock.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(holding.stock.symbol, style: text.titleMedium),
                    Text(
                      holding.stock.name,
                      style: text.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pos.valueCents == null
                        ? '–'
                        : formatMoney(pos.valueCents!, symbol),
                    style: text.titleMedium,
                  ),
                  Text(
                    pl == null
                        ? 'No price'
                        : '${formatSigned(pl, symbol)} (${formatPercent(pos.unrealizedPercent)})',
                    style: text.labelMedium?.copyWith(color: plColor(pl)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _Meta('Qty', '${pos.quantity}'),
              _Meta('Avg cost', formatMoney(pos.avgCostCents, symbol)),
              _Meta(
                'Last',
                pos.lastPriceCents == null
                    ? '–'
                    : formatMoney(pos.lastPriceCents!, symbol),
              ),
              _Meta('Held', formatDays(pos.oldestDays)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$label ', style: text.bodySmall),
          TextSpan(text: value, style: text.labelMedium),
        ],
      ),
    );
  }
}
