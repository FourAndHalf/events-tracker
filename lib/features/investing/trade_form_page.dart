import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'fifo.dart';
import 'invest_format.dart';
import 'investing_repository.dart';

/// Record (id == null) or edit a buy/sell. [stockId] and [sell] pre-fill a new trade.
class TradeFormPage extends ConsumerStatefulWidget {
  const TradeFormPage({super.key, this.id, this.stockId, this.sell = false});

  final int? id;
  final int? stockId;
  final bool sell;

  @override
  ConsumerState<TradeFormPage> createState() => _TradeFormPageState();
}

class _TradeFormPageState extends ConsumerState<TradeFormPage> {
  final _qty = TextEditingController();
  final _price = TextEditingController();
  final _fees = TextEditingController();
  final _note = TextEditingController();
  int? _stockId;
  bool _isBuy = true;
  DateTime _date = DateTime.now();
  Trade? _existing;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _stockId = widget.stockId;
    _isBuy = !widget.sell;
    for (final c in [_qty, _price, _fees]) {
      c.addListener(() => setState(() {}));
    }
    final id = widget.id;
    if (id == null) {
      _loaded = true;
    } else {
      ref.read(tradesProvider.future).then((all) {
        final t = all.where((t) => t.id == id).firstOrNull;
        if (!mounted || t == null) return;
        setState(() {
          _existing = t;
          _stockId = t.stockId;
          _isBuy = t.isBuy;
          _date = t.date;
          _qty.text = '${t.quantity}';
          _price.text = (t.priceCents / 100).toStringAsFixed(2);
          _fees.text = t.feesCents == 0
              ? ''
              : (t.feesCents / 100).toStringAsFixed(2);
          _note.text = t.note ?? '';
          _loaded = true;
        });
      });
    }
  }

  @override
  void dispose() {
    for (final c in [_qty, _price, _fees, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  int? get _qtyValue {
    final q = int.tryParse(_qty.text.trim());
    return q != null && q > 0 ? q : null;
  }

  Future<void> _addStock() async {
    final symbol = TextEditingController();
    final name = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: symbol,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(hintText: 'Symbol, e.g. AAPL'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: name,
              decoration: const InputDecoration(hintText: 'Name (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    final sym = symbol.text.trim();
    if (ok != true || sym.isEmpty) return;
    try {
      final id = await ref
          .read(investingRepositoryProvider)
          .addStock(sym, name.text.trim().isEmpty ? sym : name.text);
      if (mounted) setState(() => _stockId = id);
    } catch (_) {
      _toast('$sym already exists');
    }
  }

  /// FIFO result if this form were saved as it is now (null if the form is incomplete).
  FifoResult? _preview(List<Trade> all) {
    final stock = _stockId, qty = _qtyValue, price = parseCents(_price.text);
    if (stock == null || qty == null || price == null) return null;
    final fees = parseCentsOrZero(_fees.text) ?? 0;
    return computeFifo([
      for (final t in all)
        if (t.stockId == stock && t.id != _existing?.id) toRecord(t),
      TradeRecord(
        id: 1 << 30,
        stockId: stock,
        isBuy: _isBuy,
        date: _date,
        quantity: qty,
        priceCents: price,
        feesCents: fees,
      ),
    ]);
  }

  Future<void> _save() async {
    final stock = _stockId;
    final qty = _qtyValue;
    final price = parseCents(_price.text);
    final fees = parseCentsOrZero(_fees.text);
    if (stock == null) return _toast('Choose a stock');
    if (qty == null) return _toast('Enter a whole number of shares');
    if (price == null) return _toast('Enter a price greater than 0');
    if (fees == null) return _toast('Fees must be 0 or more');
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();
    final repo = ref.read(investingRepositoryProvider);
    try {
      final existing = _existing;
      if (existing == null) {
        await repo.addTrade(
          TradesCompanion.insert(
            stockId: stock,
            isBuy: _isBuy,
            date: _date,
            quantity: qty,
            priceCents: price,
            feesCents: Value(fees),
            note: Value(note),
          ),
        );
      } else {
        await repo.updateTrade(
          existing.copyWith(
            stockId: stock,
            isBuy: _isBuy,
            date: _date,
            quantity: qty,
            priceCents: price,
            feesCents: fees,
            note: Value(note),
          ),
        );
      }
      if (mounted) context.pop();
    } on OversellException {
      _toast('Not enough shares held for that sale');
    }
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final stocks = ref.watch(stocksProvider).value ?? const <Stock>[];
    final all = ref.watch(tradesProvider).value ?? const <Trade>[];
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? r'$';
    final text = Theme.of(context).textTheme;
    final preview = _preview(all);

    Widget? sellInfo;
    if (!_isBuy && preview != null) {
      if (!preview.isValid) {
        sellInfo = Text(
          'You do not hold that many shares on this date.',
          style: text.labelMedium?.copyWith(color: Aura.loss),
        );
      } else {
        final ms = preview.matches
            .where((m) => m.sellTradeId == (1 << 30))
            .toList();
        final pl = ms.fold<int>(0, (a, m) => a + m.profitCents);
        final days = ms.map((m) => m.daysHeld);
        if (ms.isNotEmpty) {
          final min = days.reduce((a, b) => a < b ? a : b);
          final max = days.reduce((a, b) => a > b ? a : b);
          sellInfo = AuraCard(
            borderColor: plColor(pl).withValues(alpha: 0.5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Overline('This sale'),
                      Text(
                        formatSigned(pl, sym),
                        style: text.titleLarge?.copyWith(color: plColor(pl)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Held ${holdText(min, max)}', style: text.labelMedium),
                    StatusPill(
                      label: ms.every((m) => m.isLongTerm)
                          ? 'Long-term'
                          : 'Short-term',
                      color: Aura.invest,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'New trade' : 'Edit trade'),
      ),
      body: !_loaded
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(Aura.margin),
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('Buy')),
                    ButtonSegment(value: false, label: Text('Sell')),
                  ],
                  selected: {_isBuy},
                  onSelectionChanged: (s) => setState(() => _isBuy = s.first),
                ),
                const SizedBox(height: 20),
                const Overline('Stock'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in stocks)
                      ChoiceChip(
                        label: Text(s.symbol),
                        selected: _stockId == s.id,
                        selectedColor: Aura.invest.withValues(alpha: 0.25),
                        onSelected: (_) => setState(() => _stockId = s.id),
                      ),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 18),
                      label: const Text('New stock'),
                      onPressed: _addStock,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Overline('Date'),
                const SizedBox(height: 8),
                PillButton(
                  ghost: true,
                  icon: Icons.calendar_today,
                  label: DateFormat('EEE, d MMM y').format(_date),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 1)),
                    );
                    if (d != null) setState(() => _date = d);
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _qty,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Shares'),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _price,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          prefixText: '$sym ',
                          hintText: 'Price each',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _fees,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    prefixText: '$sym ',
                    hintText: 'Fees (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _note,
                  decoration: const InputDecoration(
                    hintText: 'Note (optional)',
                  ),
                ),
                if (sellInfo != null) ...[const SizedBox(height: 16), sellInfo],
                const SizedBox(height: 20),
                PillButton(label: 'Save', color: Aura.invest, onPressed: _save),
              ],
            ),
    );
  }
}
