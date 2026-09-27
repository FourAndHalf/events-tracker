import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../core/db/app_database.dart';
import 'memories_repository.dart';

/// Full-screen viewer: swipe between an event's photos and videos.
class MediaViewerPage extends ConsumerStatefulWidget {
  const MediaViewerPage({
    super.key,
    required this.eventId,
    this.initialIndex = 0,
  });

  final int eventId;
  final int initialIndex;

  @override
  ConsumerState<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends ConsumerState<MediaViewerPage> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media =
        (ref.watch(memoryMediaProvider).value ?? const <MemoryMediaItem>[])
            .where((m) => m.eventId == widget.eventId)
            .toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(media.isEmpty ? '' : '${_index + 1} / ${media.length}'),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: media.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (_, i) => media[i].isVideo
            ? _VideoPane(key: ValueKey(media[i].id), path: media[i].path)
            : InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: Center(
                  child: Image.file(
                    File(media[i].path),
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white54,
                      size: 64,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _VideoPane extends StatefulWidget {
  const _VideoPane({super.key, required this.path});

  final String path;

  @override
  State<_VideoPane> createState() => _VideoPaneState();
}

class _VideoPaneState extends State<_VideoPane> {
  late final VideoPlayerController _c = VideoPlayerController.file(
    File(widget.path),
  );
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _c
        .initialize()
        .then((_) {
          if (mounted) setState(() => _ready = true);
        })
        .catchError((_) {
          if (mounted) setState(() => _failed = true);
        });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return const Center(child: Text("Can't play this video"));
    }
    if (!_ready) return const Center(child: CircularProgressIndicator());
    return GestureDetector(
      onTap: () => setState(() => _c.value.isPlaying ? _c.pause() : _c.play()),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _c.value.aspectRatio,
              child: VideoPlayer(_c),
            ),
          ),
          if (!_c.value.isPlaying)
            const Icon(
              Icons.play_circle_outline,
              size: 72,
              color: Colors.white70,
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: VideoProgressIndicator(_c, allowScrubbing: true),
          ),
        ],
      ),
    );
  }
}
