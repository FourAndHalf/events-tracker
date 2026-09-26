import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'money_repository.dart';

class MoneyPage extends ConsumerStatefulWidget {
  const MoneyPage({super.key});

  @override
  ConsumerState<MoneyPage> createState() => _MoneyPageState();
}

class _MoneyPageState extends ConsumerState<MoneyPage> {
  int? _categoryId;
  String? _method;
  DateTimeRange? _range;

  bool get _filtering =>
      _categoryId != null || _method != null || _range != null;

  Future<void> _pickRange() async {
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _range,
    );
    if (r != null) setState(() => _range = r);
  }

  Future<bool> _confirmDelete(Expense e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this expense?'),
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
    await ref.read(moneyRepositoryProvider).deleteExpense(e.id);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(expensesProvider).value ?? const <Expense>[];
    final cats = ref.watch(categoriesProvider).value ?? const <Category>[];
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? r'$';
    final text = Theme.of(context).textTheme;
    final catName = {for (final c in cats) c.id: c.name};

    final shown = all.where((e) {
      if (_categoryId != null && e.categoryId != _categoryId) return false;
      if (_method != null && e.paymentMethod != _method) return false;
      final r = _range;
      if (r != null) {
        final d = DateTime(e.date.year, e.date.month, e.date.day);
        if (d.isBefore(r.start) || d.isAfter(r.end)) return false;
      }
      return true;
    }).toList();
    final total = shown.fold<int>(0, (a, e) => a + e.amountCents);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money'),
        actions: [
          IconButton(
            tooltip: 'Categories & budgets',
            onPressed: () => context.push('/money/categories'),
            icon: const Icon(Icons.category_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/money/add'),
        backgroundColor: Aura.money,
        foregroundColor: Aura.canvas,
        icon: const Icon(Icons.add),
        label: const Text('Expense'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Aura.margin,
          Aura.margin,
          Aura.margin,
          96,
        ),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                PopupMenuButton<int?>(
                  onSelected: (v) => setState(() => _categoryId = v),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('All categories'),
                    ),
                    for (final c in cats)
                      PopupMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.category_outlined, size: 18),
                    label: Text(
                      _categoryId == null
                          ? 'Category'
                          : catName[_categoryId] ?? '',
                    ),
                  ),
                ),
                PopupMenuButton<String?>(
                  onSelected: (v) => setState(() => _method = v),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('All methods'),
                    ),
                    for (final m in paymentMethods)
                      PopupMenuItem(value: m, child: Text(m)),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.credit_card, size: 18),
                    label: Text(_method ?? 'Payment'),
                  ),
                ),
                ActionChip(
                  avatar: const Icon(Icons.date_range, size: 18),
                  label: Text(
                    _range == null
                        ? 'Dates'
                        : '${DateFormat('d MMM').format(_range!.start)} – ${DateFormat('d MMM').format(_range!.end)}',
                  ),
                  onPressed: _pickRange,
                ),
                if (_filtering)
                  ActionChip(
                    label: const Text('Clear'),
                    onPressed: () => setState(() {
                      _categoryId = null;
                      _method = null;
                      _range = null;
                    }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Overline(_filtering ? 'Filtered total' : 'All expenses'),
              ),
              Text(
                formatMoney(total, sym),
                style: text.titleMedium?.copyWith(color: Aura.money),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  _filtering ? 'No expenses match.' : 'No expenses yet.',
                  style: text.bodySmall,
                ),
              ),
            ),
          for (final e in shown)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Dismissible(
                key: ValueKey(e.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDelete(e),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: Aura.danger.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Aura.cardRadius),
                  ),
                  child: const Icon(Icons.delete_outline, color: Aura.danger),
                ),
                child: AuraCard(
                  onTap: () => context.push('/money/edit/${e.id}'),
                  child: Row(
                    children: [
                      IconBadge(icon: Icons.payments, color: Aura.money),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.item ??
                                  e.note ??
                                  catName[e.categoryId] ??
                                  'Expense',
                              style: text.labelLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${catName[e.categoryId] ?? ''} · ${e.paymentMethod} · ${DateFormat('d MMM').format(e.date)}',
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatMoney(e.amountCents, sym),
                        style: text.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
