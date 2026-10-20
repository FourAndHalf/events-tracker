import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/pearl_widgets.dart';
import '../../core/widgets/elapsed_text.dart';
import '../sleep/sleep_logic.dart';
import 'book_actions.dart';
import 'book_progress.dart';
import 'reading_repository.dart';
import 'reading_stats.dart';

/// Dashboard card: the running timer (with a stop button), or today's reading
/// time and the streak.
class ReadingCard extends ConsumerWidget {
  const ReadingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider).value ?? const <Book>[];
    final sessions =
        ref.watch(readingSessionsProvider).value ?? const <ReadingSession>[];
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();

    final running = sessions.where((s) => s.endAt == null).firstOrNull;
    final runningBook = running == null
        ? null
        : books.where((b) => b.id == running.bookId).firstOrNull;

    if (books.isEmpty) {
      return Module(
        onTap: () => context.go('/read'),
        child: Row(
          children: [
            const IconChip(icon: Icons.menu_book_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Reading: add your first book',
                style: text.bodyMedium,
              ),
            ),
            Icon(Icons.chevron_right, color: context.pearl.muted),
          ],
        ),
      );
    }

    if (running != null && runningBook != null) {
      return Module(
        onTap: () => context.push('/read/book/${runningBook.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ModuleHeader(
              title: 'Reading now',
              subtitle: runningBook.title,
              trailing: const StatusBadge(label: 'Timer', tone: BadgeTone.dark),
            ),
            const SizedBox(height: Pearl.spaceSm),
            ElapsedText(start: running.startAt, style: text.displaySmall),
            const SizedBox(height: Pearl.spaceMd),
            PillButton(
              label: 'Stop reading',
              icon: Icons.stop,
              onPressed: () =>
                  stopSessionFlow(context, ref, running, runningBook),
            ),
          ],
        ),
      );
    }

    final stats = sessionStats(sessions, now);
    final today = timePerDay(stats)[dayOf(now)] ?? Duration.zero;
    final streak = readingStreak(stats, now);
    return Module(
      onTap: () => context.go('/read'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModuleHeader(
            title: 'Reading',
            subtitle: 'Today',
            trailing: streak > 0
                ? StatusBadge(label: '$streak day streak')
                : null,
          ),
          const SizedBox(height: Pearl.spaceSm),
          Text(formatDuration(today), style: text.displaySmall),
        ],
      ),
    );
  }
}
