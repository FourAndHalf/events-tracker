import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

const defaultMemoryCategories = [
  'Birthday',
  'Anniversary',
  'Milestone',
  'Travel',
  'Family',
  'Other',
];

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
    MemoryCategories,
    MemoryEvents,
    MemoryMedia,
    Trackers,
    TrackerEntries,
    RecurringExpenses,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'tracker'));

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await into(settings).insert(SettingsCompanion.insert(id: const Value(1)));
      for (final name in defaultCategories) {
        await into(categories).insert(CategoriesCompanion.insert(name: name));
      }
      await _seedMemoryCategories();
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
      if (from < 4) {
        await m.createTable(memoryCategories);
        await m.createTable(memoryEvents);
        await m.createTable(memoryMedia);
        await _seedMemoryCategories();
      }
      if (from < 5) {
        await m.addColumn(settings, settings.memoryRemindMinutes);
        await m.addColumn(settings, settings.onThisDayEnabled);
      }
      if (from < 6) {
        await m.createTable(trackers);
        await m.createTable(trackerEntries);
        await m.createTable(recurringExpenses);
      }
      if (from < 7) {
        await m.addColumn(settings, settings.bedtimeReminderEnabled);
        await m.addColumn(settings, settings.bedtimeReminderLeadMinutes);
        await m.addColumn(settings, settings.expenseReminderEnabled);
        await m.addColumn(settings, settings.expenseReminderMinutes);
        // Older upgrades just created the trackers table with this column.
        if (from >= 6) await m.addColumn(trackers, trackers.reminderMinutes);
      }
      if (from < 8) {
        await m.addColumn(settings, settings.dailyPageGoal);
      }
    },
  );

  Future<void> _seedMemoryCategories() async {
    for (final name in defaultMemoryCategories) {
      await into(memoryCategories)
          .insert(MemoryCategoriesCompanion.insert(name: name));
    }
  }
}
