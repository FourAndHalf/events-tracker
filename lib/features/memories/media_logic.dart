import '../../core/db/app_database.dart';

const _videoExtensions = {
  '.mp4',
  '.mov',
  '.m4v',
  '.mkv',
  '.webm',
  '.3gp',
  '.avi',
};

/// Videos above this size ask for confirmation before being copied.
const largeVideoBytes = 200 * 1024 * 1024;

bool isVideoPath(String path) {
  final dot = path.lastIndexOf('.');
  return dot >= 0 &&
      _videoExtensions.contains(path.substring(dot).toLowerCase());
}

bool isLargeVideo(String path, int bytes) =>
    isVideoPath(path) && bytes > largeVideoBytes;

String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  const units = ['KB', 'MB', 'GB'];
  var v = bytes / 1024;
  var i = 0;
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  return '${v.toStringAsFixed(v >= 100 ? 0 : 1)} ${units[i]}';
}

/// "1:05", or "1:02:03" past an hour.
String formatClock(int ms) {
  final s = ms ~/ 1000;
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = (s % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$sec' : '$m:$sec';
}

/// The image to show for a media item: the photo itself, or a video's thumbnail.
String? previewPath(MemoryMediaItem m) => m.isVideo ? m.thumbPath : m.path;

/// The event's cover: the chosen one if it still exists, else the first photo,
/// else the first video. [media] must be one event's items in display order.
MemoryMediaItem? coverOf(MemoryEvent e, List<MemoryMediaItem> media) {
  if (media.isEmpty) return null;
  final chosen = media.where((m) => m.id == e.coverMediaId).firstOrNull;
  return chosen ?? media.where((m) => !m.isVideo).firstOrNull ?? media.first;
}
