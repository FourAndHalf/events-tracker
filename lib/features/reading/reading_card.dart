import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../sleep/sleep_logic.dart';
import 'book_actions.dart';
import 'book_progress.dart';
import 'book_widgets.dart';
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
      return AuraCard(
        onTap: () => context.go('/read'),
        child: Row(
          children: [
            const IconBadge(icon: Icons.menu_book, color: Aura.reading),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Reading: add your first book',
                style: text.bodyMedium,
              ),
            ),
            const Icon(Icons.chevron_right, color: Aura.textSecondary),
          ],
        ),
      );
    }

    if (running != null && runningBook != null) {
      return AuraCard(
        onTap: () => context.push('/read/book/${runningBook.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Overline('Reading now', color: Aura.reading),
            const SizedBox(height: 8),
            Text(runningBook.title, style: text.titleMedium),
            ElapsedText(start: running.startAt, style: text.displaySmall),
            const SizedBox(height: 12),
            PillButton(
              label: 'Stop reading',
              icon: Icons.stop,
              color: Aura.reading,
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
    return AuraCard(
      onTap: () => context.go('/read'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Overline('Reading', color: Aura.reading)),
              if (streak > 0)
                StatusPill(label: '$streak day streak', color: Aura.reading),
            ],
          ),
          const SizedBox(height: 8),
          Text('Today', style: text.bodySmall),
          Text(formatDuration(today), style: text.displaySmall),
        ],
      ),
    );
  }
}
