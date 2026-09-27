import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/charts/series.dart';
import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../../core/widgets/charts.dart';
import 'budget_logic.dart';
import 'money_charts.dart';
import 'money_repository.dart';

/// Monthly totals, spend by category and budget vs actual.
class MoneyChartsPage extends ConsumerWidget {
  const MoneyChartsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider).value ?? const <Expense>[];
    final cats = ref.watch(categoriesProvider).value ?? const <Category>[];
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? r'$';
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    final months = lastMonths(6, now);
    final totals = monthlyTotals(expenses, months);
    final byCat = categoryTotals(expenses, now, cats);
    final budgets = budgetVsActual(expenses, now, cats);
    final monthTotal = byCat.fold<int>(0, (a, c) => a + c.spentCents);

    return Scaffold(
      appBar: AppBar(title: const Text('Money charts')),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          ChartCard(
            title: 'Monthly total',
            color: Aura.money,
            subtitle: 'Last 6 months',
            child: BarChart(
              bars: [
                for (var i = 0; i < months.length; i++)
                  ChartBar(
                    DateFormat('MMM').format(months[i]),
                    totals[i] / 100,
                  ),
              ],
              color: Aura.money,
              formatValue: (v) => formatMoney((v * 100).round(), sym),
              semanticsLabel: 'Total spent per month',
            ),
          ),
          const SizedBox(height: 12),
          ChartCard(
            title: 'By category',
            color: Aura.money,
            subtitle:
                '${DateFormat('MMMM').format(now)} · ${formatMoney(monthTotal, sym)}',
            child: byCat.isEmpty
                ? Text('No spending this month.', style: text.bodySmall)
                : Column(
                    children: [
                      for (final c in byCat)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(c.name)),
                                  Text(
                                    '${formatMoney(c.spentCents, sym)} · ${(c.spentCents * 100 / monthTotal).round()}%',
                                    style: text.labelMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              AuraProgressBar(
                                value: c.spentCents / monthTotal,
                                color: Aura.money,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          ChartCard(
            title: 'Budget vs actual',
            color: Aura.money,
            subtitle: DateFormat('MMMM').format(now),
            child: budgets.isEmpty
                ? Text(
                    'Set monthly budgets on the categories page to compare.',
                    style: text.bodySmall,
                  )
                : Column(
                    children: [
                      for (final b in budgets)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(b.name)),
                                  Text(
                                    '${formatMoney(b.spentCents, sym)} of ${formatMoney(b.budgetCents!, sym)}',
                                    style: text.labelMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              AuraProgressBar(
                                value: b.spentCents / b.budgetCents!,
                                color: switch (budgetLevel(
                                  b.spentCents,
                                  b.budgetCents!,
                                )) {
                                  BudgetLevel.ok => Aura.gain,
                                  BudgetLevel.warn => Aura.money,
                                  BudgetLevel.over => Aura.loss,
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
