import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/money/money_format.dart';
import 'package:events_tracker/features/money/budget_logic.dart';
import 'package:flutter_test/flutter_test.dart';

Expense _e(int id, int cents, int cat, DateTime d) => Expense(
  id: id,
  amountCents: cents,
  categoryId: cat,
  date: d,
  paymentMethod: 'Cash',
);

void main() {
  test('budgetPercent', () {
    expect(budgetPercent(5000, 10000), 50);
    expect(budgetPercent(100, 0), 0);
  });

  test('budgetLevel thresholds', () {
    expect(budgetLevel(7999, 10000), BudgetLevel.ok);
    expect(budgetLevel(8000, 10000), BudgetLevel.warn);
    expect(budgetLevel(9999, 10000), BudgetLevel.warn);
    expect(budgetLevel(10000, 10000), BudgetLevel.over);
    expect(budgetLevel(15000, 10000), BudgetLevel.over);
    expect(budgetLevel(5000, 0), BudgetLevel.ok);
  });

  test('spendByCategory only counts the given month', () {
    final list = [
      _e(1, 1000, 1, DateTime(2026, 3, 5)),
      _e(2, 500, 1, DateTime(2026, 3, 20)),
      _e(3, 700, 2, DateTime(2026, 3, 21)),
      _e(4, 9999, 1, DateTime(2026, 2, 28)),
    ];
    expect(spendByCategory(list, DateTime(2026, 3, 1)), {1: 1500, 2: 700});
  });

  test('parseCents', () {
    expect(parseCents('12'), 1200);
    expect(parseCents('12.5'), 1250);
    expect(parseCents('12,50'), 1250);
    expect(parseCents('0.05'), 5);
    expect(parseCents('0'), isNull);
    expect(parseCents('-3'), isNull);
    expect(parseCents('1.234'), isNull);
    expect(parseCents('abc'), isNull);
  });
}
