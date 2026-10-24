import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/db/app_database.dart';
import '../../core/router/app_router.dart';
import '../reading/reading_logic.dart';
import '../reading/reading_repository.dart';
import '../sleep/sleep_repository.dart';
import 'widget_logic.dart';

/// Listens for widget button taps (while running, and the tap that started the
/// app) and performs the action.
class WidgetLinks extends ConsumerStatefulWidget {
  const WidgetLinks({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<WidgetLinks> createState() => _WidgetLinksState();
}

class _WidgetLinksState extends ConsumerState<WidgetLinks> {
  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    super.initState();
    unawaited(_listen());
  }

  Future<void> _listen() async {
    try {
      final launched = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (launched != null) _handle(launched);
      _sub = HomeWidget.widgetClicked.listen(_handle, onError: (_) {});
    } catch (e) {
      debugPrint('Widget links unavailable: $e');
    }
  }

  void _handle(Uri? uri) {
    final action = parseWidgetUri(uri);
    if (action == null) return;
    // Wait a frame so the navigator exists when the app was just started.
    WidgetsBinding.instance.addPostFrameCallback((_) => _run(action));
  }

  Future<void> _run(WidgetAction action) async {
    try {
      await runWidgetAction(action, ref);
    } catch (e) {
      debugPrint('Widget action failed: $e');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Does what a widget button promises, then shows where it happened. Both
/// buttons only add: if a session is already running, they just open it.
Future<void> runWidgetAction(WidgetAction action, WidgetRef ref) async {
  switch (action) {
    case WidgetAction.addSleep:
      final repo = ref.read(sleepRepositoryProvider);
      final open = await repo.watchOpen().first;
      appRouter.go('/sleep');
      if (open == null) await repo.start(DateTime.now());
    case WidgetAction.addRead:
      final repo = ref.read(readingRepositoryProvider);
      final books = await repo.watchBooks().first;
      final running = await repo.runningSession();
      if (running != null) {
        appRouter.go('/read/book/${running.bookId}');
        return;
      }
      final book = await _bookToRead(repo, books);
      if (book == null) {
        appRouter.go('/read');
        return;
      }
      await repo.startSession(book.id, DateTime.now());
      appRouter.go('/read/book/${book.id}');
  }
}

/// The book you read last, else any book marked as being read.
Future<Book?> _bookToRead(ReadingRepository repo, List<Book> books) async {
  final sessions = await repo.watchSessions().first; // newest first
  for (final s in sessions) {
    final b = books.where((b) => b.id == s.bookId).firstOrNull;
    if (b != null &&
        b.status != BookStatus.finished.name &&
        b.status != BookStatus.abandoned.name) {
      return b;
    }
  }
  return books.where((b) => b.status == BookStatus.reading.name).firstOrNull;
}
