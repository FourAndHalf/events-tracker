import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import 'tracker_logic.dart';

class TrackersRepository {
  TrackersRepository(this._db);
  final AppDatabase _db;

  Stream<List<Tracker>> watchTrackers() => (_db.select(
    _db.trackers,
  )..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();

  Stream<List<TrackerEntry>> watchEntries() =>
      (_db.select(_db.trackerEntries)..orderBy([
            (e) => OrderingTerm.desc(e.day),
            (e) => OrderingTerm.desc(e.id),
          ]))
          .watch();

  Future<int> addTracker(String name, String icon, TrackerType type) => _db
      .into(_db.trackers)
      .insert(
        TrackersCompanion.insert(
          name: name.trim(),
          icon: Value(icon),
          type: Value(type.name),
        ),
      );

  Future<void> updateTracker(Tracker t) => _db.update(_db.trackers).replace(t);

  Future<void> deleteTracker(int id) => _db.transaction(() async {
    await (_db.delete(
      _db.trackerEntries,
    )..where((e) => e.trackerId.equals(id))).go();
    await (_db.delete(_db.trackers)..where((t) => t.id.equals(id))).go();
  });

  /// Checks a habit off for [day], or removes the check if it was already on.
  /// Returns true when it is now checked.
  Future<bool> toggleHabit(int trackerId, DateTime day) => _db.transaction(
    () async {
      final d = dayOf(day);
      final existing = await (_db.select(
        _db.trackerEntries,
      )..where((e) => e.trackerId.equals(trackerId) & e.day.equals(d))).get();
      if (existing.isNotEmpty) {
        await (_db.delete(
          _db.trackerEntries,
        )..where((e) => e.trackerId.equals(trackerId) & e.day.equals(d))).go();
        return false;
      }
      await _db
          .into(_db.trackerEntries)
          .insert(TrackerEntriesCompanion.insert(trackerId: trackerId, day: d));
      return true;
    },
  );

  Future<TrackerEntry?> runningTimer(int trackerId) =>
      (_db.select(_db.trackerEntries)..where(
            (e) =>
                e.trackerId.equals(trackerId) &
                e.startAt.isNotNull() &
                e.endAt.isNull(),
          ))
          .getSingleOrNull();

  /// Starts a timer; does nothing if this tracker already has one running.
  Future<void> startTimer(int trackerId, DateTime now) =>
      _db.transaction(() async {
        if (await runningTimer(trackerId) != null) return;
        await _db
            .into(_db.trackerEntries)
            .insert(
              TrackerEntriesCompanion.insert(
                trackerId: trackerId,
                day: dayOf(now),
                startAt: Value(now),
              ),
            );
      });

  Future<void> stopTimer(int trackerId, DateTime now) =>
      (_db.update(_db.trackerEntries)..where(
            (e) =>
                e.trackerId.equals(trackerId) &
                e.startAt.isNotNull() &
                e.endAt.isNull(),
          ))
          .write(TrackerEntriesCompanion(endAt: Value(now)));

  Future<void> deleteEntry(int id) =>
      (_db.delete(_db.trackerEntries)..where((e) => e.id.equals(id))).go();
}

final trackersRepositoryProvider = Provider(
  (ref) => TrackersRepository(ref.watch(databaseProvider)),
);
final trackersProvider = StreamProvider(
  (ref) => ref.watch(trackersRepositoryProvider).watchTrackers(),
);
final trackerEntriesProvider = StreamProvider(
  (ref) => ref.watch(trackersRepositoryProvider).watchEntries(),
);
