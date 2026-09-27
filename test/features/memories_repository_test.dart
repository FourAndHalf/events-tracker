import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/memories/memories_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late MemoriesRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = MemoriesRepository(db);
  });
  tearDown(() => db.close());

  Future<int> event() => repo.addEvent(
    MemoryEventsCompanion.insert(
      title: 'Trip',
      categoryId: 4,
      createdAt: DateTime(2026),
      year: const Value(2024),
    ),
  );

  Future<int> media(int eventId, String path, {String? thumb}) => repo.addMedia(
    MemoryMediaCompanion.insert(
      eventId: eventId,
      path: path,
      thumbPath: Value(thumb),
    ),
  );

  test('new databases seed the default categories', () async {
    final c = await db.select(db.memoryCategories).get();
    expect(c.map((x) => x.name), defaultMemoryCategories);
  });

  test('media keeps insertion order per event', () async {
    final e = await event();
    await media(e, 'a.jpg');
    await media(e, 'b.jpg');
    final other = await event();
    await media(other, 'z.jpg');
    final m = await db.select(db.memoryMedia).get();
    expect(m.where((x) => x.eventId == e).map((x) => x.sortOrder), [0, 1]);
    expect(m.singleWhere((x) => x.eventId == other).sortOrder, 0);
  });

  test(
    'deleting media clears a cover pointing at it and returns its files',
    () async {
      final e = await event();
      final id = await media(e, 'a.jpg', thumb: 'a_t.jpg');
      await repo.setCover(e, id);
      final gone = await repo.deleteMedia(id);
      expect(gone.paths, ['a.jpg', 'a_t.jpg']);
      final ev = await db.select(db.memoryEvents).getSingle();
      expect(ev.coverMediaId, isNull);
      expect(await db.select(db.memoryMedia).get(), isEmpty);
    },
  );

  test(
    'deleting an event removes its media rows and lists every file',
    () async {
      final e = await event();
      await media(e, 'a.jpg');
      await media(e, 'v.mp4', thumb: 'v.jpg');
      final other = await event();
      await media(other, 'keep.jpg');
      final gone = await repo.deleteEvent(e);
      expect(gone.paths, ['a.jpg', 'v.mp4', 'v.jpg']);
      expect((await db.select(db.memoryMedia).get()).single.path, 'keep.jpg');
      expect(await db.select(db.memoryEvents).get(), hasLength(1));
    },
  );

  test('deleting a missing media row is harmless', () async {
    expect((await repo.deleteMedia(99)).paths, isEmpty);
  });
}
