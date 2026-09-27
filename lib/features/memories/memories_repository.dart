import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';

/// Files a deleted event or media row left behind, for the caller to remove.
class OrphanedFiles {
  const OrphanedFiles(this.paths);
  final List<String> paths;
}

class MemoriesRepository {
  MemoriesRepository(this._db);
  final AppDatabase _db;

  Stream<List<MemoryEvent>> watchEvents() => (_db.select(
    _db.memoryEvents,
  )..orderBy([(e) => OrderingTerm.asc(e.title)])).watch();

  Stream<List<MemoryMediaItem>> watchMedia() =>
      (_db.select(_db.memoryMedia)..orderBy([
            (m) => OrderingTerm.asc(m.sortOrder),
            (m) => OrderingTerm.asc(m.id),
          ]))
          .watch();

  Stream<List<MemoryCategory>> watchCategories() => (_db.select(
    _db.memoryCategories,
  )..orderBy([(c) => OrderingTerm.asc(c.id)])).watch();

  Future<int> addEvent(MemoryEventsCompanion e) =>
      _db.into(_db.memoryEvents).insert(e);

  Future<void> updateEvent(MemoryEvent e) =>
      _db.update(_db.memoryEvents).replace(e);

  /// Deletes an event and its media rows; returns the files to remove.
  Future<OrphanedFiles> deleteEvent(int id) => _db.transaction(() async {
    final media = await (_db.select(
      _db.memoryMedia,
    )..where((m) => m.eventId.equals(id))).get();
    await (_db.delete(
      _db.memoryMedia,
    )..where((m) => m.eventId.equals(id))).go();
    await (_db.delete(_db.memoryEvents)..where((e) => e.id.equals(id))).go();
    return OrphanedFiles(_filesOf(media));
  });

  List<String> _filesOf(Iterable<MemoryMediaItem> media) => [
    for (final m in media) ...[m.path, ?m.thumbPath],
  ];

  Future<int> addMedia(MemoryMediaCompanion m) async {
    final last =
        await (_db.select(_db.memoryMedia)
              ..where((x) => x.eventId.equals(m.eventId.value))
              ..orderBy([(x) => OrderingTerm.desc(x.sortOrder)])
              ..limit(1))
            .getSingleOrNull();
    return _db
        .into(_db.memoryMedia)
        .insert(m.copyWith(sortOrder: Value((last?.sortOrder ?? -1) + 1)));
  }

  /// Removes one media row; clears the event's cover if it pointed at it.
  Future<OrphanedFiles> deleteMedia(int id) => _db.transaction(() async {
    final m = await (_db.select(
      _db.memoryMedia,
    )..where((x) => x.id.equals(id))).getSingleOrNull();
    if (m == null) return const OrphanedFiles([]);
    await (_db.update(_db.memoryEvents)
          ..where((e) => e.id.equals(m.eventId) & e.coverMediaId.equals(id)))
        .write(const MemoryEventsCompanion(coverMediaId: Value(null)));
    await (_db.delete(_db.memoryMedia)..where((x) => x.id.equals(id))).go();
    return OrphanedFiles(_filesOf([m]));
  });

  Future<void> setCover(int eventId, int? mediaId) =>
      (_db.update(_db.memoryEvents)..where((e) => e.id.equals(eventId))).write(
        MemoryEventsCompanion(coverMediaId: Value(mediaId)),
      );

  Future<int> addCategory(String name) => _db
      .into(_db.memoryCategories)
      .insert(MemoryCategoriesCompanion.insert(name: name.trim()));

  Future<void> setCategoryArchived(int id, bool archived) =>
      (_db.update(_db.memoryCategories)..where((c) => c.id.equals(id))).write(
        MemoryCategoriesCompanion(archived: Value(archived)),
      );
}

final memoriesRepositoryProvider = Provider(
  (ref) => MemoriesRepository(ref.watch(databaseProvider)),
);
final memoryEventsProvider = StreamProvider(
  (ref) => ref.watch(memoriesRepositoryProvider).watchEvents(),
);
final memoryMediaProvider = StreamProvider(
  (ref) => ref.watch(memoriesRepositoryProvider).watchMedia(),
);
final memoryCategoriesProvider = StreamProvider(
  (ref) => ref.watch(memoriesRepositoryProvider).watchCategories(),
);
