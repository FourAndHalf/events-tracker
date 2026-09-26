import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'budget_logic.dart';
import 'money_repository.dart';

/// Dashboard card: today's spend and this month's spend vs total budget.
class SpendCard extends ConsumerWidget {
  const SpendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider).value ?? const [];
    final cats = ref.watch(categoriesProvider).value ?? const [];
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? r'$';
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();

    final today = sumCents(expenses.where((e) => sameDay(e.date, now)));
    final month = sumCents(expenses.where((e) => sameMonth(e.date, now)));
    final budget = cats
        .where((c) => !c.archived)
        .fold<int>(0, (a, c) => a + (c.budgetCents ?? 0));
    final level = budgetLevel(month, budget);
    final pill = switch (level) {
      BudgetLevel.ok => (budget == 0 ? 'No budget' : 'On track', Aura.habit),
      BudgetLevel.warn => ('Near limit', Aura.money),
      BudgetLevel.over => ('Over budget', Aura.danger),
    };

    return AuraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Overline('Wealth & expenses', color: Aura.money),
              ),
              StatusPill(label: pill.$1, color: pill.$2),
            ],
          ),
          const SizedBox(height: 12),
          Text('Today', style: text.bodySmall),
          Text(formatMoney(today, sym), style: text.displaySmall),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  budget == 0
                      ? 'This month ${formatMoney(month, sym)}'
                      : 'This month ${formatMoney(month, sym)} of ${formatMoney(budget, sym)}',
                  style: text.bodySmall,
                ),
              ),
              if (budget > 0)
                Text(
                  '${budgetPercent(month, budget).round()}% used',
                  style: text.labelMedium?.copyWith(color: pill.$2),
                ),
            ],
          ),
          const SizedBox(height: 8),
          AuraProgressBar(
            value: budget == 0 ? 0 : month / budget,
            color: level == BudgetLevel.over ? Aura.danger : Aura.money,
          ),
        ],
      ),
    );
  }
}
