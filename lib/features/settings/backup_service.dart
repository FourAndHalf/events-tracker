import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import 'backup_codec.dart';

class BackupService {
  BackupService(this._db);
  final AppDatabase _db;

  Future<BackupData> readAll() async => BackupData(
    settings: await (_db.select(
      _db.settings,
    )..where((s) => s.id.equals(1))).getSingle(),
    sleepSessions: await _db.select(_db.sleepSessions).get(),
    categories: await _db.select(_db.categories).get(),
    expenses: await _db.select(_db.expenses).get(),
    stocks: await _db.select(_db.stocks).get(),
    trades: await _db.select(_db.trades).get(),
    snapshots: await _db.select(_db.weeklySnapshots).get(),
    books: await _db.select(_db.books).get(),
    readingSessions: await _db.select(_db.readingSessions).get(),
    readingNotes: await _db.select(_db.readingNotes).get(),
    memoryCategories: await _db.select(_db.memoryCategories).get(),
    memoryEvents: await _db.select(_db.memoryEvents).get(),
    memoryMedia: await _db.select(_db.memoryMedia).get(),
    trackers: await _db.select(_db.trackers).get(),
    trackerEntries: await _db.select(_db.trackerEntries).get(),
    recurringExpenses: await _db.select(_db.recurringExpenses).get(),
  );

  /// Replaces every table with [d] in one transaction (all or nothing).
  Future<void> replaceAll(BackupData d) => _db.transaction(() async {
    await _db.delete(_db.recurringExpenses).go();
    await _db.delete(_db.trackerEntries).go();
    await _db.delete(_db.trackers).go();
    await _db.delete(_db.memoryMedia).go();
    await _db.delete(_db.memoryEvents).go();
    await _db.delete(_db.memoryCategories).go();
    await _db.delete(_db.readingNotes).go();
    await _db.delete(_db.readingSessions).go();
    await _db.delete(_db.books).go();
    await _db.delete(_db.trades).go();
    await _db.delete(_db.weeklySnapshots).go();
    await _db.delete(_db.stocks).go();
    await _db.delete(_db.expenses).go();
    await _db.delete(_db.categories).go();
    await _db.delete(_db.sleepSessions).go();
    await _db.delete(_db.settings).go();
    await _db.into(_db.settings).insert(d.settings.copyWith(id: 1));
    await _db.batch((b) {
      b.insertAll(_db.categories, d.categories);
      b.insertAll(_db.sleepSessions, d.sleepSessions);
      b.insertAll(_db.expenses, d.expenses);
      b.insertAll(_db.stocks, d.stocks);
      b.insertAll(_db.trades, d.trades);
      b.insertAll(_db.weeklySnapshots, d.snapshots);
      b.insertAll(_db.books, d.books);
      b.insertAll(_db.readingSessions, d.readingSessions);
      b.insertAll(_db.readingNotes, d.readingNotes);
      // Backups from before Memories carry none: keep the defaults usable.
      b.insertAll(
        _db.memoryCategories,
        d.memoryCategories.isEmpty
            ? [
                for (var i = 0; i < defaultMemoryCategories.length; i++)
                  MemoryCategory(
                    id: i + 1,
                    name: defaultMemoryCategories[i],
                    archived: false,
                  ),
              ]
            : d.memoryCategories,
      );
      b.insertAll(_db.memoryEvents, d.memoryEvents);
      b.insertAll(_db.memoryMedia, d.memoryMedia);
      b.insertAll(_db.trackers, d.trackers);
      b.insertAll(_db.trackerEntries, d.trackerEntries);
      b.insertAll(_db.recurringExpenses, d.recurringExpenses);
    });
  });

  /// Writes the JSON backup plus one CSV per table and opens the share sheet.
  Future<void> exportAndShare() async {
    final data = await readAll();
    final stamp = DateTime.now().toIso8601String().substring(0, 10);
    final dir = await Directory(
      p.join((await getTemporaryDirectory()).path, 'export'),
    ).create(recursive: true);
    final files = <XFile>[];

    Future<void> add(String name, String content) async {
      final f = File(p.join(dir.path, name));
      await f.writeAsString(content);
      files.add(XFile(f.path));
    }

    await add('tracker-backup-$stamp.json', backupToJson(data));
    for (final e in backupToCsv(data).entries) {
      await add(e.key, e.value);
    }
    await SharePlus.instance.share(
      ShareParams(files: files, subject: 'Tracker backup $stamp'),
    );
  }
}

final backupServiceProvider = Provider(
  (ref) => BackupService(ref.watch(databaseProvider)),
);
