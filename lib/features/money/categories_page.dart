import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'budget_logic.dart';
import 'money_repository.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  Future<String?> _ask(
    BuildContext context, {
    required String title,
    String initial = '',
    String? hint,
    bool money = false,
  }) {
    final c = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: c,
          autofocus: true,
          keyboardType: money
              ? const TextInputType.numberWithOptions(decimal: true)
              : null,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, c.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(categoriesProvider).value ?? const <Category>[];
    final expenses = ref.watch(expensesProvider).value ?? const <Expense>[];
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? '₹';
    final repo = ref.read(moneyRepositoryProvider);
    final spent = spendByCategory(expenses, DateTime.now());
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Categories & budgets')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final name = await _ask(context, title: 'New category', hint: 'Name');
          if (name != null && name.isNotEmpty) await repo.addCategory(name);
        },
        backgroundColor: Aura.money,
        foregroundColor: Aura.canvas,
        icon: const Icon(Icons.add),
        label: const Text('Category'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Aura.margin,
          Aura.margin,
          Aura.margin,
          96,
        ),
        children: [
          Text(
            'Monthly budget per category. Warnings appear at 80% and 100%.',
            style: text.bodySmall,
          ),
          const SizedBox(height: 12),
          for (final c in cats)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Opacity(
                opacity: c.archived ? 0.5 : 1,
                child: AuraCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.archived ? '${c.name} (archived)' : c.name,
                              style: text.titleMedium,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (v) async {
                              if (v == 'rename') {
                                final n = await _ask(
                                  context,
                                  title: 'Rename',
                                  initial: c.name,
                                );
                                if (n != null && n.isNotEmpty) {
                                  await repo.updateCategory(
                                    c.id,
                                    CategoriesCompanion(name: Value(n)),
                                  );
                                }
                              } else if (v == 'archive') {
                                await repo.updateCategory(
                                  c.id,
                                  CategoriesCompanion(
                                    archived: Value(!c.archived),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'rename',
                                child: Text('Rename'),
                              ),
                              PopupMenuItem(
                                value: 'archive',
                                child: Text(c.archived ? 'Restore' : 'Archive'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          final v = await _ask(
                            context,
                            title: 'Monthly budget for ${c.name}',
                            initial: c.budgetCents == null
                                ? ''
                                : (c.budgetCents! / 100).toStringAsFixed(2),
                            hint: 'Leave empty for no budget',
                            money: true,
                          );
                          if (v == null) return;
                          final cents = v.isEmpty ? null : parseCents(v);
                          if (v.isNotEmpty && cents == null) return;
                          await repo.updateCategory(
                            c.id,
                            CategoriesCompanion(budgetCents: Value(cents)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            c.budgetCents == null
                                ? 'Set a monthly budget'
                                : 'Budget ${formatMoney(c.budgetCents!, sym)} · spent ${formatMoney(spent[c.id] ?? 0, sym)}',
                            style: text.labelLarge?.copyWith(color: Aura.money),
                          ),
                        ),
                      ),
                      if (c.budgetCents != null)
                        AuraProgressBar(
                          value: (spent[c.id] ?? 0) / c.budgetCents!,
                          color:
                              budgetLevel(spent[c.id] ?? 0, c.budgetCents!) ==
                                  BudgetLevel.over
                              ? Aura.danger
                              : Aura.money,
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
