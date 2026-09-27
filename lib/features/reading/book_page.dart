import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../../core/widgets/elapsed_text.dart';
import '../sleep/sleep_logic.dart';
import 'book_actions.dart';
import 'book_progress.dart';
import 'book_widgets.dart';
import 'reading_logic.dart';
import 'reading_repository.dart';

/// One book: progress, the timer, sessions and notes.
class BookPage extends ConsumerWidget {
  const BookPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = (ref.watch(booksProvider).value ?? const <Book>[])
        .where((b) => b.id == id)
        .firstOrNull;
    if (book == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }
    final all =
        ref.watch(readingSessionsProvider).value ?? const <ReadingSession>[];
    final sessions = all.where((s) => s.bookId == id).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
    final notes =
        (ref.watch(readingNotesProvider).value ?? const <ReadingNote>[])
            .where((n) => n.bookId == id)
            .toList();
    final running = all.where((s) => s.endAt == null).firstOrNull;
    final runningHere = running?.bookId == id;
    final status = BookStatus.parse(book.status);
    final page = currentPage(sessions);
    final progress = progressFraction(page, book.totalPages);
    final pages = pagesBySession(sessions);
    final text = Theme.of(context).textTheme;
    final fmt = DateFormat('EEE d MMM, HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () => context.push('/read/edit/${book.id}'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookCover(book: book, width: 80),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title, style: text.headlineSmall),
                    if (book.author.isNotEmpty)
                      Text(book.author, style: text.bodyMedium),
                    const SizedBox(height: 8),
                    StatusPill(label: status.label, color: statusColor(status)),
                    if (book.rating != null) ...[
                      const SizedBox(height: 8),
                      RatingStars(rating: book.rating),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AuraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Overline('Progress', color: Aura.reading),
                const SizedBox(height: 8),
                Text(
                  book.totalPages == null
                      ? (page == null ? 'No pages logged yet' : 'Page $page')
                      : 'Page ${page ?? 0} of ${book.totalPages}'
                            '${progress == null ? '' : ' · ${(progress * 100).round()}%'}',
                  style: text.titleMedium,
                ),
                if (progress != null) ...[
                  const SizedBox(height: 8),
                  AuraProgressBar(value: progress, color: Aura.reading),
                ],
                const SizedBox(height: 16),
                if (runningHere) ...[
                  ElapsedText(
                    start: running!.startAt,
                    style: text.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  PillButton(
                    label: 'Stop reading',
                    icon: Icons.stop,
                    color: Aura.reading,
                    onPressed: () =>
                        stopSessionFlow(context, ref, running, book),
                  ),
                ] else
                  PillButton(
                    label: 'Start reading',
                    icon: Icons.play_arrow,
                    color: Aura.reading,
                    onPressed: running != null || status == BookStatus.finished
                        ? null
                        : () => startSessionFlow(context, ref, book),
                  ),
                if (running != null && !runningHere)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Another book has a timer running.',
                      style: text.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              if (status != BookStatus.finished)
                PillButton(
                  label: 'Mark finished',
                  icon: Icons.check,
                  ghost: true,
                  onPressed: () => finishBook(context, ref, book),
                ),
              if (status != BookStatus.abandoned &&
                  status != BookStatus.finished)
                PillButton(
                  label: 'Abandon',
                  ghost: true,
                  onPressed: () => ref
                      .read(readingRepositoryProvider)
                      .setStatus(book, BookStatus.abandoned),
                ),
              if (status == BookStatus.finished ||
                  status == BookStatus.abandoned)
                PillButton(
                  label: 'Read again',
                  ghost: true,
                  onPressed: () => ref
                      .read(readingRepositoryProvider)
                      .setStatus(book, BookStatus.reading),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Overline('Notes and quotes')),
              TextButton.icon(
                onPressed: () => _addNote(context, ref, book),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          if (notes.isEmpty) Text('Nothing yet.', style: text.bodySmall),
          for (final n in notes)
            Dismissible(
              key: ValueKey('note-${n.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Aura.loss.withValues(alpha: 0.3),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete_outline),
              ),
              onDismissed: (_) =>
                  ref.read(readingRepositoryProvider).deleteNote(n.id),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  n.isQuote ? Icons.format_quote : Icons.notes,
                  color: Aura.reading,
                ),
                title: Text(
                  n.body,
                  style: n.isQuote
                      ? text.bodyMedium?.copyWith(fontStyle: FontStyle.italic)
                      : text.bodyMedium,
                ),
                subtitle: Text(
                  DateFormat('d MMM').format(n.createdAt) +
                      (n.sessionId == null ? '' : ' · from a session'),
                  style: text.bodySmall,
                ),
              ),
            ),
          const SizedBox(height: 24),
          const Overline('Sessions'),
          const SizedBox(height: 4),
          if (sessions.isEmpty) Text('No sessions yet.', style: text.bodySmall),
          for (final s in sessions.reversed)
            Dismissible(
              key: ValueKey('session-${s.id}'),
              direction: s.endAt == null
                  ? DismissDirection.none
                  : DismissDirection.endToStart,
              background: Container(
                color: Aura.loss.withValues(alpha: 0.3),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete_outline),
              ),
              onDismissed: (_) =>
                  ref.read(readingRepositoryProvider).deleteSession(s.id),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(fmt.format(s.startAt)),
                subtitle: Text(
                  s.endAt == null
                      ? 'Running'
                      : '${formatDuration(sessionDuration(s.startAt, s.endAt, s.endAt!))}'
                            '${s.endPage == null ? '' : ' · to page ${s.endPage}'}'
                            '${(pages[s.id] ?? 0) > 0 ? ' · ${pages[s.id]} pages' : ''}',
                  style: text.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _addNote(BuildContext context, WidgetRef ref, Book book) async {
    final controller = TextEditingController();
    var quote = false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Add note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('This is a quote'),
                value: quote,
                onChanged: (v) => setState(() => quote = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    final body = controller.text.trim();
    controller.dispose();
    if (ok == true && body.isNotEmpty) {
      await ref
          .read(readingRepositoryProvider)
          .addNote(book.id, body, isQuote: quote);
    }
  }
}
