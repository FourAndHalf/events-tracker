import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'investing_repository.dart';
import 'portfolio.dart';
import 'portfolio_provider.dart';

/// One list to type today's price for every stock you hold.
class PricesPage extends ConsumerStatefulWidget {
  const PricesPage({super.key});

  @override
  ConsumerState<PricesPage> createState() => _PricesPageState();
}

class _PricesPageState extends ConsumerState<PricesPage> {
  final _controllers = <int, TextEditingController>{};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controller(Holding h) => _controllers.putIfAbsent(
    h.stock.id,
    () => TextEditingController(
      text: h.stock.lastPriceCents == null
          ? ''
          : (h.stock.lastPriceCents! / 100).toStringAsFixed(2),
    ),
  );

  Future<void> _save(List<Holding> holdings) async {
    final repo = ref.read(investingRepositoryProvider);
    final today = DateTime.now();
    var saved = 0;
    for (final h in holdings) {
      final raw = _controller(h).text.trim();
      if (raw.isEmpty) continue;
      final cents = parseCents(raw);
      if (cents == null) {
        _toast('Check the price for ${h.stock.symbol}');
        return;
      }
      if (cents != h.stock.lastPriceCents || isPriceStale(h.stock, today)) {
        await repo.setPrice(h.stock.id, cents, today);
        saved++;
      }
    }
    if (!mounted) return;
    _toast(saved == 0 ? 'No changes' : 'Prices updated');
    if (saved > 0) context.pop();
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final holdings = ref.watch(portfolioProvider).open.toList();
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? '₹';
    final text = Theme.of(context).textTheme;
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Update prices')),
      body: holdings.isEmpty
          ? Center(child: Text('No shares held.', style: text.bodySmall))
          : ListView(
              padding: const EdgeInsets.all(Aura.margin),
              children: [
                Text(
                  'Type the latest price for each stock. Prices are entered by hand; the app stays offline.',
                  style: text.bodySmall,
                ),
                const SizedBox(height: 16),
                for (final h in holdings)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AuraCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(h.stock.symbol, style: text.titleMedium),
                                _Age(stock: h.stock, today: today),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: TextField(
                              controller: _controller(h),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                prefixText: '$sym ',
                                hintText: '0.00',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                PillButton(
                  label: 'Save prices',
                  color: Aura.invest,
                  onPressed: () => _save(holdings),
                ),
              ],
            ),
    );
  }
}

class _Age extends StatelessWidget {
  const _Age({required this.stock, required this.today});

  final Stock stock;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final age = priceAgeDays(stock, today);
    if (age == null) {
      return const StatusPill(label: 'No price yet', color: Aura.money);
    }
    final stale = isPriceStale(stock, today);
    return StatusPill(
      label: age == 0 ? 'Updated today' : '$age days old',
      color: stale ? Aura.money : Aura.gain,
    );
  }
}
