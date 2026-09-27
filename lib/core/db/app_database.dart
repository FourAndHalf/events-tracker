import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

const defaultCategories = [
  'Food',
  'Transport',
  'Bills',
  'Shopping',
  'Health',
  'Other',
];

@DriftDatabase(
  tables: [
    Settings,
    SleepSessions,
    Categories,
    Expenses,
    Stocks,
    Trades,
    WeeklySnapshots,
    Books,
    ReadingSessions,
    ReadingNotes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'tracker'));

  @override
  int get schemaVersion => 3;

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
      if (from < 2) {
        await m.createTable(stocks);
        await m.createTable(trades);
        await m.createTable(weeklySnapshots);
        await m.addColumn(settings, settings.weeklyReportEnabled);
        await m.addColumn(settings, settings.weeklyReportMinutes);
      }
      if (from < 3) {
        await m.createTable(books);
        await m.createTable(readingSessions);
        await m.createTable(readingNotes);
      }
    },
  );
}
