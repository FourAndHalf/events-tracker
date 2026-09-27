import '../../core/db/app_database.dart';
import 'budget_logic.dart';

/// Total spent in each of [months] (first-of-month dates), in cents.
List<int> monthlyTotals(Iterable<Expense> expenses, List<DateTime> months) => [
  for (final m in months) sumCents(expenses.where((e) => sameMonth(e.date, m))),
];

class CategorySpend {
  const CategorySpend(this.name, this.spentCents, this.budgetCents);

  final String name;
  final int spentCents;

  /// Monthly budget, or null when the category has none.
  final int? budgetCents;
}

/// Spend per category in [month], biggest first; categories with no spend are
/// left out.
List<CategorySpend> categoryTotals(
  Iterable<Expense> expenses,
  DateTime month,
  Iterable<Category> cats,
) {
  final spend = spendByCategory(expenses, month);
  return [
    for (final c in cats)
      if ((spend[c.id] ?? 0) > 0)
        CategorySpend(c.name, spend[c.id]!, c.budgetCents),
  ]..sort((a, b) => b.spentCents.compareTo(a.spentCents));
}

/// Active categories with a budget, with what was spent in [month] (even 0).
List<CategorySpend> budgetVsActual(
  Iterable<Expense> expenses,
  DateTime month,
  Iterable<Category> cats,
) {
  final spend = spendByCategory(expenses, month);
  return [
    for (final c in cats)
      if (!c.archived && (c.budgetCents ?? 0) > 0)
        CategorySpend(c.name, spend[c.id] ?? 0, c.budgetCents),
  ];
}
