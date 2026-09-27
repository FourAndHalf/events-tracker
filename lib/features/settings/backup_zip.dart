import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart' show Value;
import 'package:path/path.dart' as p;

import '../../core/db/app_database.dart';
import 'backup_codec.dart';
import 'backup_service.dart';

const zipJsonName = 'backup.json';

class ZipPlan {
  const ZipPlan(this.data, this.files);

  /// Backup data with media paths rewritten to names inside the zip.
  final BackupData data;

  /// Source file on disk and the name it gets in the zip.
  final List<({String source, String zipName})> files;
}

/// Decides what goes into a full backup, without touching the disk. With
/// [includeVideos] false the video rows are left out (and a cover that pointed
/// at one is cleared) so the backup stays small.
ZipPlan planZip(BackupData d, {required bool includeVideos}) {
  final kept = [
    for (final m in d.memoryMedia)
      if (includeVideos || !m.isVideo) m,
  ];
  final keptIds = {for (final m in kept) m.id};
  final files = <({String source, String zipName})>[];
  final rewritten = <MemoryMediaItem>[];
  for (final m in kept) {
    final zipName = 'media/${m.id}${p.extension(m.path)}';
    files.add((source: m.path, zipName: zipName));
    String? thumbZip;
    if (m.thumbPath != null) {
      thumbZip = 'media/${m.id}_thumb${p.extension(m.thumbPath!)}';
      files.add((source: m.thumbPath!, zipName: thumbZip));
    }
    rewritten.add(m.copyWith(path: zipName, thumbPath: Value(thumbZip)));
  }
  final events = [
    for (final e in d.memoryEvents)
      e.coverMediaId != null && !keptIds.contains(e.coverMediaId)
          ? e.copyWith(coverMediaId: const Value(null))
          : e,
  ];
  return ZipPlan(
    BackupData(
      settings: d.settings,
      sleepSessions: d.sleepSessions,
      categories: d.categories,
      expenses: d.expenses,
      stocks: d.stocks,
      trades: d.trades,
      snapshots: d.snapshots,
      books: d.books,
      readingSessions: d.readingSessions,
      readingNotes: d.readingNotes,
      memoryCategories: d.memoryCategories,
      memoryEvents: events,
      memoryMedia: rewritten,
    ),
    files,
  );
}

/// Size of the media a backup would carry (thumbnails are negligible).
({int photos, int videos}) mediaSizes(Iterable<MemoryMediaItem> media) {
  var photos = 0;
  var videos = 0;
  for (final m in media) {
    if (m.isVideo) {
      videos += m.sizeBytes;
    } else {
      photos += m.sizeBytes;
    }
  }
  return (photos: photos, videos: videos);
}

/// Writes the full backup zip to [outPath]. Files are streamed into the zip one
/// at a time, so large videos are never held in memory.
Future<File> writeBackupZip(
  BackupData d,
  String outPath, {
  required bool includeVideos,
}) async {
  final plan = planZip(d, includeVideos: includeVideos);
  final encoder = ZipFileEncoder()..create(outPath);
  encoder.addArchiveFile(
    ArchiveFile.bytes(zipJsonName, utf8.encode(backupToJson(plan.data))),
  );
  for (final f in plan.files) {
    final file = File(f.source);
    if (await file.exists()) await encoder.addFile(file, f.zipName);
  }
  await encoder.close();
  return File(outPath);
}

/// Restores a full backup: unpacks [zip] into [tmp], moves the media under
/// `[mediaRoot]/<eventId>/`, replaces all data, then deletes media files of the
/// data that was replaced. All-or-nothing for the database; on failure the
/// newly copied files are removed again.
Future<BackupData> importBackupZip({
  required File zip,
  required BackupService service,
  required Directory tmp,
  required Directory mediaRoot,
}) async {
  if (await tmp.exists()) await tmp.delete(recursive: true);
  await tmp.create(recursive: true);
  await extractFileToDisk(zip.path, tmp.path);
  final jsonFile = File(p.join(tmp.path, zipJsonName));
  if (!await jsonFile.exists()) {
    throw const FormatException('This zip is not a tracker backup');
  }
  final data = backupFromJson(await jsonFile.readAsString());

  final stamp = DateTime.now().microsecondsSinceEpoch;
  final copied = <String>[];
  Future<String> place(MemoryMediaItem m, String rel, String tag) async {
    final dir = await Directory(p.join(mediaRoot.path, '${m.eventId}'))
        .create(recursive: true);
    final dest = p.join(dir.path, '${stamp}_$tag${p.extension(rel)}');
    final src = File(p.join(tmp.path, rel));
    if (await src.exists()) {
      await src.copy(dest);
      copied.add(dest);
    }
    return dest;
  }

  try {
    final media = <MemoryMediaItem>[];
    for (final m in data.memoryMedia) {
      final path = await place(m, m.path, '${m.id}');
      final thumb = m.thumbPath == null
          ? null
          : await place(m, m.thumbPath!, '${m.id}_thumb');
      media.add(m.copyWith(path: path, thumbPath: Value(thumb)));
    }
    final oldMedia = (await service.readAll()).memoryMedia;
    await service.replaceAll(
      BackupData(
        settings: data.settings,
        sleepSessions: data.sleepSessions,
        categories: data.categories,
        expenses: data.expenses,
        stocks: data.stocks,
        trades: data.trades,
        snapshots: data.snapshots,
        books: data.books,
        readingSessions: data.readingSessions,
        readingNotes: data.readingNotes,
        memoryCategories: data.memoryCategories,
        memoryEvents: data.memoryEvents,
        memoryMedia: media,
      ),
    );
    final keep = copied.toSet();
    for (final m in oldMedia) {
      for (final path in [m.path, ?m.thumbPath]) {
        if (!keep.contains(path)) {
          try {
            await File(path).delete();
          } on FileSystemException {
            // Already gone.
          }
        }
      }
    }
  } catch (_) {
    for (final f in copied) {
      try {
        await File(f).delete();
      } on FileSystemException {
        // Nothing to clean.
      }
    }
    rethrow;
  } finally {
    await tmp.delete(recursive: true);
  }
  return data;
}
