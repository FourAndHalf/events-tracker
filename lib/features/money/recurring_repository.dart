import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import 'recurring_logic.dart';

class RecurringRepository {
  RecurringRepository(this._db);
  final AppDatabase _db;

  Stream<List<RecurringExpense>> watchAll() => (_db.select(
    _db.recurringExpenses,
  )..orderBy([(r) => OrderingTerm.asc(r.id)])).watch();

  Future<int> add(RecurringExpensesCompanion r) =>
      _db.into(_db.recurringExpenses).insert(r);

  Future<void> update(RecurringExpense r) =>
      _db.update(_db.recurringExpenses).replace(r);

  Future<void> delete(int id) =>
      (_db.delete(_db.recurringExpenses)..where((r) => r.id.equals(id))).go();

  /// Creates every expense that has come due up to [now], for active rules,
  /// in one transaction. Safe to call any number of times: each rule remembers
  /// the last date it produced. Returns how many expenses were created.
  Future<int> generateDue(DateTime now) => _db.transaction(() async {
    var created = 0;
    final rules = await (_db.select(
      _db.recurringExpenses,
    )..where((r) => r.active.equals(true))).get();
    for (final r in rules) {
      final dates = dueDates(
        Frequency.parse(r.frequency),
        r.startDate,
        r.lastGeneratedDate,
        now,
      );
      if (dates.isEmpty) continue;
      for (final d in dates) {
        await _db
            .into(_db.expenses)
            .insert(
              ExpensesCompanion.insert(
                amountCents: r.amountCents,
                categoryId: r.categoryId,
                date: d,
                paymentMethod: r.paymentMethod,
                note: Value(r.note),
                item: Value(r.item),
                store: Value(r.store),
              ),
            );
        created++;
      }
      await (_db.update(
        _db.recurringExpenses,
      )..where((x) => x.id.equals(r.id))).write(
        RecurringExpensesCompanion(lastGeneratedDate: Value(dates.last)),
      );
    }
    return created;
  });
}

final recurringRepositoryProvider = Provider(
  (ref) => RecurringRepository(ref.watch(databaseProvider)),
);
final recurringProvider = StreamProvider(
  (ref) => ref.watch(recurringRepositoryProvider).watchAll(),
);

/// Adds due recurring expenses at app start and whenever the rules change.
final recurringGeneratorProvider = Provider<void>((ref) {
  final rules = ref.watch(recurringProvider).value;
  if (rules == null || rules.isEmpty) return;
  ref.read(recurringRepositoryProvider).generateDue(DateTime.now()).ignore();
});
