import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/memories/memories_repository.dart';
import 'package:events_tracker/features/settings/backup_service.dart';
import 'package:events_tracker/features/settings/backup_zip.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tmp;
  late AppDatabase src;
  late int eventId;
  late int photoId;
  late int videoId;

  Future<File> write(String rel, List<int> bytes) async {
    final f = File(p.join(tmp.path, rel));
    await f.create(recursive: true);
    await f.writeAsBytes(bytes);
    return f;
  }

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('zip_test');
    src = AppDatabase(NativeDatabase.memory());
    final repo = MemoriesRepository(src);
    eventId = await repo.addEvent(
      MemoryEventsCompanion.insert(
        title: 'Goa trip',
        categoryId: 4,
        createdAt: DateTime(2026),
        year: const Value(2019),
      ),
    );
    final photo = await write('app/$eventId/a.jpg', [1, 2, 3, 4]);
    final video = await write('app/$eventId/v.mp4', List.filled(50, 9));
    final thumb = await write('app/$eventId/v_thumb.jpg', [5, 6]);
    photoId = await repo.addMedia(
      MemoryMediaCompanion.insert(
        eventId: eventId,
        path: photo.path,
        sizeBytes: const Value(4),
      ),
    );
    videoId = await repo.addMedia(
      MemoryMediaCompanion.insert(
        eventId: eventId,
        path: video.path,
        isVideo: const Value(true),
        thumbPath: Value(thumb.path),
        durationMs: const Value(12000),
        sizeBytes: const Value(50),
      ),
    );
    await repo.setCover(eventId, videoId);
  });

  tearDown(() async {
    await src.close();
    await tmp.delete(recursive: true);
  });

  test('size preview splits photos and videos', () async {
    final m = await src.select(src.memoryMedia).get();
    expect(mediaSizes(m), (photos: 4, videos: 50));
  });

  test(
    'plan without videos drops them and clears a cover pointing at one',
    () async {
      final data = await BackupService(src).readAll();
      final plan = planZip(data, includeVideos: false);
      expect(plan.data.memoryMedia.map((m) => m.id), [photoId]);
      expect(plan.data.memoryEvents.single.coverMediaId, isNull);
      expect(plan.files.map((f) => f.zipName), ['media/$photoId.jpg']);
      final full = planZip(data, includeVideos: true);
      expect(full.data.memoryEvents.single.coverMediaId, videoId);
      expect(full.files.map((f) => f.zipName), [
        'media/$photoId.jpg',
        'media/$videoId.mp4',
        'media/${videoId}_thumb.jpg',
      ]);
    },
  );

  test('full round trip restores events and media files', () async {
    final zip = await writeBackupZip(
      await BackupService(src).readAll(),
      p.join(tmp.path, 'backup.zip'),
      includeVideos: true,
    );
    expect(await zip.exists(), isTrue);

    final dst = AppDatabase(NativeDatabase.memory());
    addTearDown(dst.close);
    final root = Directory(p.join(tmp.path, 'restored'));
    await importBackupZip(
      zip: zip,
      service: BackupService(dst),
      tmp: Directory(p.join(tmp.path, 'unpack')),
      mediaRoot: root,
    );

    final event = await dst.select(dst.memoryEvents).getSingle();
    expect(event.title, 'Goa trip');
    expect(event.coverMediaId, videoId);
    final media = await dst.select(dst.memoryMedia).get();
    expect(media, hasLength(2));
    for (final m in media) {
      expect(m.path.startsWith(p.join(root.path, '$eventId')), isTrue);
      expect(File(m.path).existsSync(), isTrue);
    }
    final photo = media.firstWhere((m) => !m.isVideo);
    expect(await File(photo.path).readAsBytes(), [1, 2, 3, 4]);
    final video = media.firstWhere((m) => m.isVideo);
    expect(video.durationMs, 12000);
    expect(await File(video.thumbPath!).readAsBytes(), [5, 6]);
    expect(Directory(p.join(tmp.path, 'unpack')).existsSync(), isFalse);
  });

  test('importing replaces data and deletes the old media files', () async {
    final zip = await writeBackupZip(
      await BackupService(src).readAll(),
      p.join(tmp.path, 'backup.zip'),
      includeVideos: false,
    );
    // The target already has its own memory with a file on disk.
    final dst = AppDatabase(NativeDatabase.memory());
    addTearDown(dst.close);
    final dstRepo = MemoriesRepository(dst);
    final oldEvent = await dstRepo.addEvent(
      MemoryEventsCompanion.insert(
        title: 'Old',
        categoryId: 1,
        createdAt: DateTime(2026),
        year: const Value(2000),
      ),
    );
    final oldFile = await write('dst/$oldEvent/old.jpg', [7]);
    await dstRepo.addMedia(
      MemoryMediaCompanion.insert(eventId: oldEvent, path: oldFile.path),
    );

    await importBackupZip(
      zip: zip,
      service: BackupService(dst),
      tmp: Directory(p.join(tmp.path, 'unpack')),
      mediaRoot: Directory(p.join(tmp.path, 'dst')),
    );
    expect(oldFile.existsSync(), isFalse);
    expect((await dst.select(dst.memoryEvents).getSingle()).title, 'Goa trip');
    final media = await dst.select(dst.memoryMedia).getSingle();
    expect(media.isVideo, isFalse); // videos were left out
    expect(File(media.path).existsSync(), isTrue);
  });

  test('a zip without backup.json is rejected and leaves data alone', () async {
    final bad = await write('bad.zip', [0]);
    final dst = AppDatabase(NativeDatabase.memory());
    addTearDown(dst.close);
    await expectLater(
      importBackupZip(
        zip: bad,
        service: BackupService(dst),
        tmp: Directory(p.join(tmp.path, 'unpack')),
        mediaRoot: Directory(p.join(tmp.path, 'x')),
      ),
      throwsA(anything),
    );
    expect(await dst.select(dst.memoryEvents).get(), isEmpty);
  });
}
