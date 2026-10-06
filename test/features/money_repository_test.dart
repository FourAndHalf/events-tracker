import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/money/money_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late MoneyRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = MoneyRepository(db);
  });

  tearDown(() => db.close());

  test('deletes an expense from the detailed expense flow', () async {
    final id = await repo.addExpense(
      ExpensesCompanion.insert(
        amountCents: 1250,
        categoryId: 1,
        date: DateTime(2026, 10, 6),
        paymentMethod: 'Cash',
      ),
    );

    await repo.deleteExpense(id);

    expect(await repo.getExpense(id), isNull);
    expect(await repo.watchExpenses().first, isEmpty);
  });
}
