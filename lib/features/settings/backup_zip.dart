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
  final books = [
    for (final b in d.books)
      if (b.coverPath == null)
        b
      else
        b.copyWith(coverPath: Value(_addFile(files, b.coverPath!, 'covers'))),
  ];
  final expenses = [
    for (final e in d.expenses)
      if (e.receiptPath == null)
        e
      else
        e.copyWith(
          receiptPath: Value(_addFile(files, e.receiptPath!, 'receipts')),
        ),
  ];
  return ZipPlan(
    BackupData(
      settings: d.settings,
      sleepSessions: d.sleepSessions,
      categories: d.categories,
      expenses: expenses,
      stocks: d.stocks,
      trades: d.trades,
      snapshots: d.snapshots,
      books: books,
      readingSessions: d.readingSessions,
      readingNotes: d.readingNotes,
      memoryCategories: d.memoryCategories,
      memoryEvents: events,
      memoryMedia: rewritten,
      trackers: d.trackers,
      trackerEntries: d.trackerEntries,
      recurringExpenses: d.recurringExpenses,
    ),
    files,
  );
}

/// Queues [sourcePath] to be added under [folder] in the zip and returns its
/// zip-relative name. File names in `covers/`/`receipts/` are already unique
/// (timestamp-based), so the source's own basename is reused.
String _addFile(
  List<({String source, String zipName})> files,
  String sourcePath,
  String folder,
) {
  final zipName = '$folder/${p.basename(sourcePath)}';
  files.add((source: sourcePath, zipName: zipName));
  return zipName;
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
/// `[mediaRoot]/<eventId>/`, book covers into [coversRoot] and expense
/// receipts into [receiptsRoot], replaces all data, then deletes files of the
/// data that was replaced. All-or-nothing for the database; on failure the
/// newly copied files are removed again.
Future<BackupData> importBackupZip({
  required File zip,
  required BackupService service,
  required Directory tmp,
  required Directory mediaRoot,
  required Directory coversRoot,
  required Directory receiptsRoot,
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

  /// Restores a flat (non-per-entity) file, like a cover or a receipt, that
  /// was only added to the zip when its `rel` path points inside it.
  Future<String> placeFlat(Directory root, String rel, String tag) async {
    if (!rel.startsWith('$tag/')) return rel;
    await root.create(recursive: true);
    final dest = p.join(root.path, '${stamp}_${p.basename(rel)}');
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
    final books = <Book>[];
    for (final b in data.books) {
      books.add(
        b.coverPath == null
            ? b
            : b.copyWith(
                coverPath: Value(
                  await placeFlat(coversRoot, b.coverPath!, 'covers'),
                ),
              ),
      );
    }
    final expenses = <Expense>[];
    for (final e in data.expenses) {
      expenses.add(
        e.receiptPath == null
            ? e
            : e.copyWith(
                receiptPath: Value(
                  await placeFlat(receiptsRoot, e.receiptPath!, 'receipts'),
                ),
              ),
      );
    }
    final old = await service.readAll();
    final oldMedia = old.memoryMedia;
    await service.replaceAll(
      BackupData(
        settings: data.settings,
        sleepSessions: data.sleepSessions,
        categories: data.categories,
        expenses: expenses,
        stocks: data.stocks,
        trades: data.trades,
        snapshots: data.snapshots,
        books: books,
        readingSessions: data.readingSessions,
        readingNotes: data.readingNotes,
        memoryCategories: data.memoryCategories,
        memoryEvents: data.memoryEvents,
        memoryMedia: media,
        trackers: data.trackers,
        trackerEntries: data.trackerEntries,
        recurringExpenses: data.recurringExpenses,
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
    for (final path in [
      for (final b in old.books) ?b.coverPath,
      for (final e in old.expenses) ?e.receiptPath,
    ]) {
      if (!keep.contains(path)) {
        try {
          await File(path).delete();
        } on FileSystemException {
          // Already gone.
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
