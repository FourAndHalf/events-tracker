import '../../core/db/app_database.dart';

enum BudgetLevel { ok, warn, over }

/// Percent of [budgetCents] used (0 when there is no budget).
double budgetPercent(int spentCents, int budgetCents) =>
    budgetCents <= 0 ? 0 : spentCents * 100 / budgetCents;

/// ok below 80%, warn from 80% up to 100%, over at 100% or more.
BudgetLevel budgetLevel(int spentCents, int budgetCents) {
  final p = budgetPercent(spentCents, budgetCents);
  if (p >= 100) return BudgetLevel.over;
  if (p >= 80) return BudgetLevel.warn;
  return BudgetLevel.ok;
}

bool sameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

bool sameDay(DateTime a, DateTime b) => sameMonth(a, b) && a.day == b.day;

int sumCents(Iterable<Expense> list) =>
    list.fold(0, (a, e) => a + e.amountCents);

/// Total spent in [month], per category id.
Map<int, int> spendByCategory(Iterable<Expense> expenses, DateTime month) {
  final out = <int, int>{};
  for (final e in expenses.where((e) => sameMonth(e.date, month))) {
    out[e.categoryId] = (out[e.categoryId] ?? 0) + e.amountCents;
  }
  return out;
}
