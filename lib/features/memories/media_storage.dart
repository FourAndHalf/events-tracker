import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../core/db/app_database.dart';
import 'media_logic.dart';
import 'memories_repository.dart';

/// Duration and thumbnail for a copied video; either may be missing.
typedef VideoInfo = ({int? durationMs, String? thumbPath});
typedef VideoInfoReader = Future<VideoInfo> Function(String videoPath);

Future<VideoInfo> readVideoInfo(String videoPath) async {
  String? thumb;
  int? duration;
  try {
    final dest = '${p.withoutExtension(videoPath)}_thumb.jpg';
    final ok = await FcNativeVideoThumbnail().saveThumbnailToFile(
      srcFile: videoPath,
      destFile: dest,
      width: 480,
      height: 480,
      quality: 75,
    );
    if (ok) thumb = dest;
  } catch (_) {
    // No thumbnail: the grid falls back to a video icon.
  }
  try {
    final c = VideoPlayerController.file(File(videoPath));
    await c.initialize();
    duration = c.value.duration.inMilliseconds;
    await c.dispose();
  } catch (_) {
    // Duration unknown: the badge is simply omitted.
  }
  return (durationMs: duration, thumbPath: thumb);
}

Future<Directory> memoriesRoot() async => Directory(
  p.join((await getApplicationDocumentsDirectory()).path, 'memories'),
);

/// Copies [files] into `<root>/<eventId>/` and records them. Returns how many
/// were added. Copies, so deleting the originals from the gallery is safe.
Future<int> importMedia({
  required MemoriesRepository repo,
  required Directory root,
  required int eventId,
  required List<XFile> files,
  VideoInfoReader videoInfo = readVideoInfo,
}) async {
  final dir = await Directory(p.join(root.path, '$eventId'))
      .create(recursive: true);
  var added = 0;
  for (final f in files) {
    final ext = p.extension(f.path).isEmpty ? '.jpg' : p.extension(f.path);
    final dest = p.join(
      dir.path,
      '${DateTime.now().microsecondsSinceEpoch}_$added$ext',
    );
    await File(f.path).copy(dest);
    final video = isVideoPath(dest);
    final info = video ? await videoInfo(dest) : null;
    final size = await File(dest).length();
    await repo.addMedia(
      MemoryMediaCompanion.insert(
        eventId: eventId,
        path: dest,
        isVideo: Value(video),
        thumbPath: Value(info?.thumbPath),
        durationMs: Value(info?.durationMs),
        sizeBytes: Value(size),
      ),
    );
    added++;
  }
  return added;
}

/// Removes files we stored; ignores ones that are already gone.
Future<void> deleteFiles(Iterable<String> paths) async {
  for (final path in paths) {
    try {
      await File(path).delete();
    } on FileSystemException {
      // Already gone: nothing to do.
    }
  }
}

/// Sum of stored media sizes.
int totalMediaBytes(Iterable<MemoryMediaItem> media) =>
    media.fold(0, (a, m) => a + m.sizeBytes);
