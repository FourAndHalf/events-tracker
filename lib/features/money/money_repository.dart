import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';

const paymentMethods = ['Cash', 'Card', 'Bank / UPI', 'Other'];

class MoneyRepository {
  MoneyRepository(this._db);
  final AppDatabase _db;

  Stream<List<Expense>> watchExpenses() =>
      (_db.select(_db.expenses)..orderBy([
            (e) => OrderingTerm.desc(e.date),
            (e) => OrderingTerm.desc(e.id),
          ]))
          .watch();

  Stream<List<Category>> watchCategories() => (_db.select(
    _db.categories,
  )..orderBy([(c) => OrderingTerm.asc(c.name)])).watch();

  Future<Expense?> getExpense(int id) => (_db.select(
    _db.expenses,
  )..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<int> addExpense(ExpensesCompanion e) =>
      _db.into(_db.expenses).insert(e);

  Future<void> updateExpense(Expense e) => _db.update(_db.expenses).replace(e);

  Future<void> deleteExpense(int id) =>
      (_db.delete(_db.expenses)..where((e) => e.id.equals(id))).go();

  Future<void> addCategory(String name) =>
      _db.into(_db.categories).insert(CategoriesCompanion.insert(name: name));

  Future<void> updateCategory(int id, CategoriesCompanion changes) =>
      (_db.update(
        _db.categories,
      )..where((c) => c.id.equals(id))).write(changes);
}

final moneyRepositoryProvider = Provider(
  (ref) => MoneyRepository(ref.watch(databaseProvider)),
);

final expensesProvider = StreamProvider(
  (ref) => ref.watch(moneyRepositoryProvider).watchExpenses(),
);
final categoriesProvider = StreamProvider(
  (ref) => ref.watch(moneyRepositoryProvider).watchCategories(),
);
