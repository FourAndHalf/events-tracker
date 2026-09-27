import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('v1 database upgrades to the latest schema keeping data and adding new tables', () async {
    final db = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute('''
            CREATE TABLE settings (
              id INTEGER NOT NULL, currency_symbol TEXT NOT NULL DEFAULT '\$',
              sleep_goal_minutes INTEGER NOT NULL DEFAULT 480,
              target_bedtime_minutes INTEGER NOT NULL DEFAULT 1380, PRIMARY KEY (id));
            INSERT INTO settings (id, currency_symbol, sleep_goal_minutes) VALUES (1, '€', 420);
            CREATE TABLE categories (
              id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
              budget_cents INTEGER NULL, archived INTEGER NOT NULL DEFAULT 0);
            INSERT INTO categories (name) VALUES ('Food');
            PRAGMA user_version = 1;
          ''');
        },
      ),
    );
    addTearDown(db.close);

    final s = await (db.select(db.settings)).getSingle();
    expect(s.currencySymbol, '€'); // old data kept
    expect(s.sleepGoalMinutes, 420);
    expect(s.weeklyReportEnabled, isTrue); // new columns get defaults
    expect(s.weeklyReportMinutes, 1140);
    expect((await db.select(db.categories).get()).single.name, 'Food');
    expect(await db.select(db.stocks).get(), isEmpty); // new tables exist
    expect(await db.select(db.trades).get(), isEmpty);
    expect(await db.select(db.weeklySnapshots).get(), isEmpty);
    expect(await db.select(db.books).get(), isEmpty); // v3 tables exist
    expect(await db.select(db.readingSessions).get(), isEmpty);
    expect(await db.select(db.readingNotes).get(), isEmpty);
  });

  test(
    'v6 database gains the reminder columns and keeps its trackers',
    () async {
      final db = AppDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            raw.execute('''
            CREATE TABLE settings (
              id INTEGER NOT NULL, currency_symbol TEXT NOT NULL DEFAULT '\$',
              sleep_goal_minutes INTEGER NOT NULL DEFAULT 480,
              target_bedtime_minutes INTEGER NOT NULL DEFAULT 1380,
              weekly_report_enabled INTEGER NOT NULL DEFAULT 1,
              weekly_report_minutes INTEGER NOT NULL DEFAULT 1140,
              memory_remind_minutes INTEGER NOT NULL DEFAULT 540,
              on_this_day_enabled INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (id));
            INSERT INTO settings (id) VALUES (1);
            CREATE TABLE trackers (
              id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
              icon TEXT NOT NULL DEFAULT 'star', type TEXT NOT NULL DEFAULT 'habit',
              archived INTEGER NOT NULL DEFAULT 0);
            INSERT INTO trackers (name) VALUES ('Meditate');
            PRAGMA user_version = 6;
          ''');
          },
        ),
      );
      addTearDown(db.close);
      final t = await db.select(db.trackers).getSingle();
      expect((t.name, t.reminderMinutes), ('Meditate', null));
      final s = await db.select(db.settings).getSingle();
      expect(
        (
          s.bedtimeReminderEnabled,
          s.bedtimeReminderLeadMinutes,
          s.expenseReminderMinutes,
        ),
        (false, 30, 1260),
      );
    },
  );
}
