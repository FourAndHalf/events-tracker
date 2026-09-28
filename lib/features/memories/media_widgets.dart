import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/db/app_database.dart';
import '../../core/media/image_compress.dart';
import '../../core/theme/aura_colors.dart';
import 'media_logic.dart';

/// Square thumbnail of a media item (video: thumbnail + duration badge).
class MediaThumb extends StatelessWidget {
  const MediaThumb({
    super.key,
    required this.item,
    this.size,
    this.badge = true,
  });

  final MemoryMediaItem item;
  final double? size;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final path = previewPath(item);
    final radius = BorderRadius.circular(12);
    Widget fallback() => Container(
      color: Aura.raised,
      alignment: Alignment.center,
      child: Icon(
        item.isVideo ? Icons.videocam : Icons.broken_image_outlined,
        color: Aura.textSecondary,
      ),
    );
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            path == null
                ? fallback()
                : Image.file(
                    File(path),
                    fit: BoxFit.cover,
                    cacheWidth: 360,
                    errorBuilder: (_, _, _) => fallback(),
                  ),
            if (badge && item.isVideo)
              Positioned(
                right: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.play_arrow,
                        size: 14,
                        color: Colors.white,
                      ),
                      if (item.durationMs != null)
                        Text(
                          formatClock(item.durationMs!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Asks before copying videos over [largeVideoBytes]. Returns the files to keep.
Future<List<XFile>> confirmLargeVideos(
  BuildContext context,
  List<XFile> files,
) async {
  final large = <XFile>[];
  for (final f in files) {
    if (isVideoPath(f.path) && isLargeVideo(f.path, await f.length())) {
      large.add(f);
    }
  }
  if (large.isEmpty || !context.mounted) return files;
  final total = (await Future.wait(large.map((f) => f.length())))
      .fold<int>(0, (a, b) => a + b);
  if (!context.mounted) return files;
  final keep = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Large video'),
      content: Text(
        '${large.length == 1 ? 'This video is' : '${large.length} videos are'} '
        '${formatBytes(total)} and will be copied into the app, using that much storage.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Skip large'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Add anyway'),
        ),
      ],
    ),
  );
  return keep == true ? files : files.where((f) => !large.contains(f)).toList();
}

/// Gallery (several at once), camera photo and video recording.
class MediaPickButtons extends StatelessWidget {
  const MediaPickButtons({super.key, required this.onPicked});

  final Future<void> Function(List<XFile> files) onPicked;

  Future<void> _deliver(BuildContext context, List<XFile> files) async {
    if (files.isEmpty) return;
    final ok = await confirmLargeVideos(context, files);
    if (ok.isNotEmpty) await onPicked(ok);
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ActionChip(
          avatar: const Icon(Icons.photo_library_outlined, size: 18),
          label: const Text('Gallery'),
          onPressed: () async {
            final files = await picker.pickMultipleMedia();
            if (context.mounted) await _deliver(context, files);
          },
        ),
        ActionChip(
          avatar: const Icon(Icons.photo_camera_outlined, size: 18),
          label: const Text('Photo'),
          onPressed: () async {
            final f = await picker.pickImage(source: ImageSource.camera);
            if (context.mounted && f != null) await _deliver(context, [f]);
          },
        ),
        ActionChip(
          avatar: const Icon(Icons.videocam_outlined, size: 18),
          label: const Text('Video'),
          onPressed: () async {
            final f = await picker.pickVideo(source: ImageSource.camera);
            if (context.mounted && f != null) await _deliver(context, [f]);
          },
        ),
        ActionChip(
          avatar: const Icon(Icons.cloud_outlined, size: 18),
          label: const Text('Google Photos'),
          onPressed: () async {
            final picked = await FilePicker.pickFiles(type: FileType.image);
            if (picked.isEmpty) return;
            final tempDir = await getTemporaryDirectory();
            final files = <XFile>[];
            for (final f in picked) {
              final path = f.path;
              if (path == null) continue;
              final dest = p.join(
                tempDir.path,
                '${DateTime.now().microsecondsSinceEpoch}_${files.length}.jpg',
              );
              await compressImageTo(path, dest);
              files.add(XFile(dest));
            }
            if (context.mounted) await _deliver(context, files);
          },
        ),
      ],
    );
  }
}
