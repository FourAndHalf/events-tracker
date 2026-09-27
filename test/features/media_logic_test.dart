import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/memories/media_logic.dart';
import 'package:events_tracker/features/memories/media_storage.dart';
import 'package:events_tracker/features/memories/memories_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

MemoryMediaItem item(int id, {bool video = false, String? thumb}) =>
    MemoryMediaItem(
      id: id,
      eventId: 1,
      path: '/m/$id',
      isVideo: video,
      thumbPath: thumb,
      sortOrder: id,
      sizeBytes: 0,
    );

MemoryEvent event({int? cover}) => MemoryEvent(
  id: 1,
  title: 'E',
  kind: 'oneTime',
  precision: 'day',
  categoryId: 1,
  coverMediaId: cover,
  remindOnDay: false,
  remindDaysBefore: '',
  createdAt: DateTime(2026),
);

void main() {
  test('video detection is case-insensitive and by extension', () {
    expect(isVideoPath('/a/b.MP4'), isTrue);
    expect(isVideoPath('/a/b.mov'), isTrue);
    expect(isVideoPath('/a/b.jpg'), isFalse);
    expect(isVideoPath('/a/noext'), isFalse);
  });

  test('large-video threshold applies to videos only', () {
    expect(isLargeVideo('x.mp4', largeVideoBytes + 1), isTrue);
    expect(isLargeVideo('x.mp4', largeVideoBytes), isFalse);
    expect(isLargeVideo('x.jpg', largeVideoBytes * 5), isFalse);
  });

  test('byte and clock formatting', () {
    expect(formatBytes(512), '512 B');
    expect(formatBytes(1536), '1.5 KB');
    expect(formatBytes(5 * 1024 * 1024), '5.0 MB');
    expect(formatBytes(300 * 1024 * 1024), '300 MB');
    expect(formatClock(65000), '1:05');
    expect(formatClock(3723000), '1:02:03');
    expect(formatClock(9000), '0:09');
  });

  test('cover: chosen if present, else first photo, else first video', () {
    final media = [item(1, video: true, thumb: 't'), item(2), item(3)];
    expect(coverOf(event(cover: 3), media)?.id, 3);
    expect(coverOf(event(cover: 99), media)?.id, 2); // stale id
    expect(coverOf(event(), media)?.id, 2);
    expect(coverOf(event(), [item(1, video: true)])?.id, 1);
    expect(coverOf(event(), const []), isNull);
  });

  test('a video previews as its thumbnail, a photo as itself', () {
    expect(previewPath(item(1, video: true, thumb: 't.jpg')), 't.jpg');
    expect(previewPath(item(1, video: true)), isNull);
    expect(previewPath(item(2)), '/m/2');
  });

  group('importMedia', () {
    late Directory tmp;
    late AppDatabase db;
    late MemoriesRepository repo;
    late int eventId;

    setUp(() async {
      tmp = await Directory.systemTemp.createTemp('mem_test');
      db = AppDatabase(NativeDatabase.memory());
      repo = MemoriesRepository(db);
      eventId = await repo.addEvent(
        MemoryEventsCompanion.insert(
          title: 'Trip',
          categoryId: 4,
          createdAt: DateTime(2026),
          year: const Value(2024),
        ),
      );
    });
    tearDown(() async {
      await db.close();
      await tmp.delete(recursive: true);
    });

    Future<XFile> source(String name, int bytes) async {
      final f = File(p.join(tmp.path, 'gallery', name));
      await f.create(recursive: true);
      await f.writeAsBytes(List.filled(bytes, 7));
      return XFile(f.path);
    }

    test('copies files into the app folder so the originals can go', () async {
      final photo = await source('a.jpg', 10);
      final video = await source('v.mp4', 20);
      final root = Directory(p.join(tmp.path, 'app'));
      final n = await importMedia(
        repo: repo,
        root: root,
        eventId: eventId,
        files: [photo, video],
        videoInfo: (path) async => (durationMs: 65000, thumbPath: null),
      );
      expect(n, 2);
      final rows = await db.select(db.memoryMedia).get();
      expect(rows.map((r) => r.isVideo), [false, true]);
      expect(rows.map((r) => r.sizeBytes), [10, 20]);
      expect(rows[1].durationMs, 65000);
      for (final r in rows) {
        expect(r.path.startsWith(p.join(root.path, '$eventId')), isTrue);
        expect(File(r.path).existsSync(), isTrue);
      }
      await File(photo.path).delete(); // "deleted from the gallery"
      expect(File(rows[0].path).existsSync(), isTrue);
      expect(totalMediaBytes(rows), 30);
    });

    test('deleting an event removes its files from disk', () async {
      final root = Directory(p.join(tmp.path, 'app'));
      await importMedia(
        repo: repo,
        root: root,
        eventId: eventId,
        files: [await source('a.jpg', 5), await source('b.jpg', 5)],
      );
      final paths = (await db.select(db.memoryMedia).get())
          .map((r) => r.path)
          .toList();
      final gone = await repo.deleteEvent(eventId);
      await deleteFiles(gone.paths);
      expect(paths.every((x) => !File(x).existsSync()), isTrue);
      expect(await db.select(db.memoryMedia).get(), isEmpty);
      await deleteFiles(['/no/such/file']); // harmless
    });
  });
}
