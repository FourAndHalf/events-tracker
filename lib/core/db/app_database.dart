import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

const defaultCategories = ['Food', 'Transport', 'Bills', 'Shopping', 'Health', 'Other'];

@DriftDatabase(tables: [Settings, SleepSessions, Categories, Expenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'tracker'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(settings).insert(SettingsCompanion.insert(id: const Value(1)));
          for (final name in defaultCategories) {
            await into(categories).insert(CategoriesCompanion.insert(name: name));
          }
        },
        onUpgrade: (m, from, to) async {
          // Future migrations go here, one step per version.
        },
      );
}
