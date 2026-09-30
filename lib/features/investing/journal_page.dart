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
import 'portfolio.dart';
import 'portfolio_provider.dart';

enum _Result { all, wins, losses }

class JournalPage extends ConsumerStatefulWidget {
  const JournalPage({super.key});

  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage> {
  int? _stockId;
  DateTimeRange? _range;
  _Result _result = _Result.all;

  bool get _filtering =>
      _stockId != null || _range != null || _result != _Result.all;

  Future<bool> _delete(Trade t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this trade?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return false;
    try {
      await ref.read(investingRepositoryProvider).deleteTrade(t);
      return true;
    } on OversellException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot delete: a later sale needs these shares'),
          ),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trades = ref.watch(tradesProvider).value ?? const <Trade>[];
    final stocks = ref.watch(stocksProvider).value ?? const <Stock>[];
    final portfolio = ref.watch(portfolioProvider);
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? '₹';
    final text = Theme.of(context).textTheme;
    final symbolOf = {for (final s in stocks) s.id: s.symbol};

    final shown = trades.where((t) {
      if (_stockId != null && t.stockId != _stockId) return false;
      final r = _range;
      if (r != null) {
        final d = DateTime(t.date.year, t.date.month, t.date.day);
        if (d.isBefore(r.start) || d.isAfter(r.end)) return false;
      }
      if (_result != _Result.all) {
        final s = portfolio.sales[t.id];
        if (t.isBuy || s == null) return false;
        if (_result == _Result.wins ? !s.isWin : s.profitCents >= 0) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Trade journal')),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                PopupMenuButton<int?>(
                  onSelected: (v) => setState(() => _stockId = v),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: null, child: Text('All stocks')),
                    for (final s in stocks)
                      PopupMenuItem(value: s.id, child: Text(s.symbol)),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.show_chart, size: 18),
                    label: Text(
                      _stockId == null ? 'Stock' : symbolOf[_stockId] ?? '',
                    ),
                  ),
                ),
                ActionChip(
                  avatar: const Icon(Icons.date_range, size: 18),
                  label: Text(
                    _range == null
                        ? 'Dates'
                        : '${DateFormat('d MMM').format(_range!.start)} – ${DateFormat('d MMM').format(_range!.end)}',
                  ),
                  onPressed: () async {
                    final r = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDateRange: _range,
                    );
                    if (r != null) setState(() => _range = r);
                  },
                ),
                for (final r in _Result.values)
                  ChoiceChip(
                    label: Text(switch (r) {
                      _Result.all => 'All',
                      _Result.wins => 'Wins',
                      _Result.losses => 'Losses',
                    }),
                    selected: _result == r,
                    onSelected: (_) => setState(() => _result = r),
                  ),
                if (_filtering)
                  ActionChip(
                    label: const Text('Clear'),
                    onPressed: () => setState(() {
                      _stockId = null;
                      _range = null;
                      _result = _Result.all;
                    }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  _filtering ? 'No trades match.' : 'No trades yet.',
                  style: text.bodySmall,
                ),
              ),
            ),
          for (final t in shown)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Dismissible(
                key: ValueKey(t.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _delete(t),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: Aura.danger.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Aura.cardRadius),
                  ),
                  child: const Icon(Icons.delete_outline, color: Aura.danger),
                ),
                child: _TradeTile(
                  trade: t,
                  symbol: symbolOf[t.stockId] ?? '',
                  sale: portfolio.sales[t.id],
                  currency: sym,
                  onTap: () => context.push('/invest/trade/${t.id}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TradeTile extends StatelessWidget {
  const _TradeTile({
    required this.trade,
    required this.symbol,
    required this.sale,
    required this.currency,
    required this.onTap,
  });

  final Trade trade;
  final String symbol;
  final SaleSummary? sale;
  final String currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final sale = this.sale;
    return AuraCard(
      onTap: onTap,
      child: Row(
        children: [
          StatusPill(
            label: trade.isBuy ? 'Buy' : 'Sell',
            color: trade.isBuy ? Aura.invest : Aura.money,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$symbol · ${trade.quantity} @ ${formatMoney(trade.priceCents, currency)}',
                  style: text.labelLarge,
                ),
                Text(
                  DateFormat('d MMM y').format(trade.date),
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          if (sale != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatSigned(sale.profitCents, currency),
                  style: text.labelLarge?.copyWith(
                    color: plColor(sale.profitCents),
                  ),
                ),
                Text(
                  'Held ${holdText(sale.minDays, sale.maxDays)}',
                  style: text.bodySmall,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
