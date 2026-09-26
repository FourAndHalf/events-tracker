import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/settings/backup_codec.dart';
import 'package:events_tracker/features/settings/backup_service.dart';
import 'package:flutter_test/flutter_test.dart';

Future<AppDatabase> _seeded() async {
  final db = AppDatabase(NativeDatabase.memory());
  await db
      .into(db.sleepSessions)
      .insert(
        SleepSessionsCompanion.insert(
          sleepAt: DateTime(2026, 1, 1, 23),
          wakeAt: Value(DateTime(2026, 1, 2, 7)),
          quality: const Value(4),
          note: const Value('said "ok", fine'),
        ),
      );
  await db
      .into(db.expenses)
      .insert(
        ExpensesCompanion.insert(
          amountCents: 1250,
          categoryId: 1,
          date: DateTime(2026, 1, 3),
          paymentMethod: 'Card',
          item: const Value('Kettle'),
          warrantyOrReturnBy: Value(DateTime(2027, 1, 3)),
        ),
      );
  return db;
}

void main() {
  test('export -> import into a fresh database restores everything', () async {
    final src = await _seeded();
    final json = backupToJson(await BackupService(src).readAll());
    await src.close();

    final dst = AppDatabase(NativeDatabase.memory());
    addTearDown(dst.close);
    await BackupService(dst).replaceAll(backupFromJson(json));

    final sleep = await dst.select(dst.sleepSessions).getSingle();
    expect(sleep.wakeAt, DateTime(2026, 1, 2, 7));
    expect(sleep.note, 'said "ok", fine');
    final exp = await dst.select(dst.expenses).getSingle();
    expect(exp.amountCents, 1250);
    expect(exp.item, 'Kettle');
    expect(exp.warrantyOrReturnBy, DateTime(2027, 1, 3));
    expect(
      (await dst.select(dst.categories).get()).length,
      defaultCategories.length,
    );
  });

  test('import replaces existing data instead of merging', () async {
    final src = await _seeded();
    final data = await BackupService(src).readAll();
    await src.close();

    final dst = await _seeded();
    addTearDown(dst.close);
    await BackupService(dst).replaceAll(data);
    expect((await dst.select(dst.expenses).get()).length, 1);
    expect((await dst.select(dst.sleepSessions).get()).length, 1);
  });

  test('rejects files that are not backups', () {
    expect(() => backupFromJson('not json'), throwsFormatException);
    expect(() => backupFromJson('{"a":1}'), throwsFormatException);
    expect(
      () => backupFromJson('{"format":"events-tracker-backup","version":99}'),
      throwsFormatException,
    );
    expect(
      () => backupFromJson(
        '{"format":"events-tracker-backup","version":1,"settings":5}',
      ),
      throwsFormatException,
    );
  });

  test('CSV has a header, ISO dates and escaped quotes', () async {
    final db = await _seeded();
    addTearDown(db.close);
    final csv = backupToCsv(await BackupService(db).readAll());
    final sleepCsv = csv['sleep_sessions.csv']!.split('\n');
    expect(sleepCsv.first, 'id,sleepAt,wakeAt,quality,note');
    expect(sleepCsv[1], contains('2026-01-01T23:00:00'));
    expect(sleepCsv[1], contains('"said ""ok"", fine"'));
    expect(csv.keys, containsAll(['categories.csv', 'expenses.csv']));
  });
}
