import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/db/app_database.dart';
import '../../core/router/app_router.dart';
import '../reading/book_actions.dart';
import '../reading/reading_logic.dart';
import '../reading/reading_repository.dart';
import '../sleep/sleep_repository.dart';
import '../sleep/wake_prompt.dart';
import 'widget_logic.dart';

const _androidWidget = 'EventsWidgetProvider';

/// Keeps the labels on the home-screen widget in step with the app. Every
/// call is wrapped: a widget problem must never break the app (and tests run
/// without the plugin).
final widgetSyncProvider = Provider<void>((ref) {
  final open = ref.watch(openSleepProvider).value;
  final sessions = ref.watch(readingSessionsProvider).value;
  final books = ref.watch(booksProvider).value;
  if (sessions == null || books == null) return;
  final running = sessions.where((s) => s.endAt == null).firstOrNull;
  final title = running == null
      ? null
      : books.where((b) => b.id == running.bookId).firstOrNull?.title;
  unawaited(() async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'sleep_label',
        sleepWidgetLabel(open?.sleepAt),
      );
      await HomeWidget.saveWidgetData<String>(
        'read_label',
        readWidgetLabel(title),
      );
      await HomeWidget.updateWidget(androidName: _androidWidget);
    } catch (e) {
      debugPrint('Widget not updated: $e');
    }
  }());
});

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

BuildContext? _navContext() =>
    appRouter.routerDelegate.navigatorKey.currentContext;

/// Does what a widget button promises, then shows where it happened.
Future<void> runWidgetAction(WidgetAction action, WidgetRef ref) async {
  switch (action) {
    case WidgetAction.addExpense:
      appRouter.go('/');
      appRouter.push('/money/add');
    case WidgetAction.sleepToggle:
      final repo = ref.read(sleepRepositoryProvider);
      final open = await repo.watchOpen().first;
      appRouter.go('/sleep');
      if (open == null) {
        await repo.start(DateTime.now());
        return;
      }
      await repo.wake(open.id, DateTime.now());
      final ctx = _navContext();
      if (ctx == null || !ctx.mounted) return;
      final answer = await showWakePrompt(ctx);
      if (answer != null) {
        await repo.setQuality(open.id, answer.quality, answer.note);
      }
    case WidgetAction.readToggle:
      final repo = ref.read(readingRepositoryProvider);
      final books = await repo.watchBooks().first;
      final running = await repo.runningSession();
      if (running != null) {
        final book = books.where((b) => b.id == running.bookId).firstOrNull;
        if (book == null) return;
        appRouter.go('/read/book/${book.id}');
        await Future<void>.delayed(const Duration(milliseconds: 400));
        final ctx = _navContext();
        if (ctx != null && ctx.mounted) {
          await stopSessionFlow(ctx, ref, running, book);
        }
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
