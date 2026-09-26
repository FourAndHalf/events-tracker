import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';

class SleepRepository {
  SleepRepository(this._db);
  final AppDatabase _db;

  Stream<List<SleepSession>> watchAll() => (_db.select(
    _db.sleepSessions,
  )..orderBy([(s) => OrderingTerm.desc(s.sleepAt)])).watch();

  Stream<SleepSession?> watchOpen() =>
      (_db.select(_db.sleepSessions)
            ..where((s) => s.wakeAt.isNull())
            ..limit(1))
          .watchSingleOrNull();

  Stream<SleepSession?> watchLastCompleted() =>
      (_db.select(_db.sleepSessions)
            ..where((s) => s.wakeAt.isNotNull())
            ..orderBy([(s) => OrderingTerm.desc(s.wakeAt)])
            ..limit(1))
          .watchSingleOrNull();

  Future<SleepSession?> get(int id) => (_db.select(
    _db.sleepSessions,
  )..where((s) => s.id.equals(id))).getSingleOrNull();

  /// Starts a night. Only one open session is allowed at a time.
  Future<void> start(DateTime now) async {
    final open = await (_db.select(
      _db.sleepSessions,
    )..where((s) => s.wakeAt.isNull())).get();
    if (open.isNotEmpty) return;
    await _db
        .into(_db.sleepSessions)
        .insert(SleepSessionsCompanion.insert(sleepAt: now));
  }

  Future<void> wake(int id, DateTime now) =>
      (_db.update(_db.sleepSessions)..where((s) => s.id.equals(id))).write(
        SleepSessionsCompanion(wakeAt: Value(now)),
      );

  Future<void> setQuality(int id, int? quality, String? note) =>
      (_db.update(_db.sleepSessions)..where((s) => s.id.equals(id))).write(
        SleepSessionsCompanion(quality: Value(quality), note: Value(note)),
      );

  Future<void> update(SleepSession s) =>
      _db.update(_db.sleepSessions).replace(s);

  Future<void> delete(int id) =>
      (_db.delete(_db.sleepSessions)..where((s) => s.id.equals(id))).go();
}

final sleepRepositoryProvider = Provider(
  (ref) => SleepRepository(ref.watch(databaseProvider)),
);

final sleepListProvider = StreamProvider(
  (ref) => ref.watch(sleepRepositoryProvider).watchAll(),
);
final openSleepProvider = StreamProvider(
  (ref) => ref.watch(sleepRepositoryProvider).watchOpen(),
);
final lastSleepProvider = StreamProvider(
  (ref) => ref.watch(sleepRepositoryProvider).watchLastCompleted(),
);
