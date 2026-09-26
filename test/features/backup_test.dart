import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/investing/investing_repository.dart';
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

  test(
    'investing data (stocks, trades, snapshots) survives export -> import',
    () async {
      final src = await _seeded();
      final repo = InvestingRepository(src);
      final stockId = await repo.addStock('AAPL', 'Apple');
      await repo.setPrice(stockId, 15025, DateTime(2026, 3, 1));
      await repo.addTrade(
        TradesCompanion.insert(
          stockId: stockId,
          isBuy: true,
          date: DateTime(2026, 1, 5),
          quantity: 10,
          priceCents: 14000,
          feesCents: const Value(150),
          note: const Value('first buy'),
        ),
      );
      await repo.upsertSnapshot(DateTime(2026, 3, 2), 140150, 150250);
      final json = backupToJson(await BackupService(src).readAll());
      await src.close();

      final dst = AppDatabase(NativeDatabase.memory());
      addTearDown(dst.close);
      await BackupService(dst).replaceAll(backupFromJson(json));

      final stock = await dst.select(dst.stocks).getSingle();
      expect(stock.symbol, 'AAPL');
      expect(stock.lastPriceCents, 15025);
      final trade = await dst.select(dst.trades).getSingle();
      expect(trade.stockId, stock.id);
      expect(trade.feesCents, 150);
      expect(trade.note, 'first buy');
      final snap = await dst.select(dst.weeklySnapshots).getSingle();
      expect(snap.valueCents, 150250);
    },
  );

  test('a backup made before Investing existed still imports', () async {
    const old = '''
{"format":"events-tracker-backup","version":1,
 "settings":{"id":1,"currencySymbol":"€","sleepGoalMinutes":450,"targetBedtimeMinutes":1380},
 "sleepSessions":[],"categories":[{"id":1,"name":"Food","budgetCents":null,"archived":false}],
 "expenses":[]}''';
    final data = backupFromJson(old);
    expect(data.stocks, isEmpty);
    expect(data.trades, isEmpty);
    expect(data.settings.weeklyReportEnabled, isTrue);
    expect(data.settings.weeklyReportMinutes, 1140);

    final dst = AppDatabase(NativeDatabase.memory());
    addTearDown(dst.close);
    await BackupService(dst).replaceAll(data);
    expect((await dst.select(dst.settings).getSingle()).currencySymbol, '€');
  });

  test('CSV export includes the investing tables', () async {
    final db = await _seeded();
    addTearDown(db.close);
    final repo = InvestingRepository(db);
    final id = await repo.addStock('MSFT', 'Microsoft');
    await repo.addTrade(
      TradesCompanion.insert(
        stockId: id,
        isBuy: true,
        date: DateTime(2026, 1, 5),
        quantity: 2,
        priceCents: 100,
      ),
    );
    final csv = backupToCsv(await BackupService(db).readAll());
    expect(
      csv.keys,
      containsAll(['stocks.csv', 'trades.csv', 'weekly_snapshots.csv']),
    );
    expect(
      csv['trades.csv']!.split('\n').first,
      startsWith('id,stockId,isBuy,date'),
    );
    expect(csv['stocks.csv'], contains('MSFT'));
  });
}
