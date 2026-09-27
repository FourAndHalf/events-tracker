import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import '../../core/widgets/home_button.dart';
import 'book_progress.dart';
import 'book_widgets.dart';
import 'reading_logic.dart';
import 'reading_repository.dart';

/// The library: every book, filterable by status.
class ReadingPage extends ConsumerStatefulWidget {
  const ReadingPage({super.key});

  @override
  ConsumerState<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends ConsumerState<ReadingPage> {
  BookStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider).value ?? const <Book>[];
    final sessions =
        ref.watch(readingSessionsProvider).value ?? const <ReadingSession>[];
    final text = Theme.of(context).textTheme;
    final shown = books
        .where((b) => _filter == null || b.status == _filter!.name)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: const HomeButton(),
        title: const Text('Reading'),
        actions: [
          IconButton(
            tooltip: 'Stats',
            onPressed: () => context.push('/read/stats'),
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/read/edit'),
        backgroundColor: Aura.reading,
        foregroundColor: Aura.canvas,
        icon: const Icon(Icons.add),
        label: const Text('Book'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Aura.margin,
          Aura.margin,
          Aura.margin,
          96,
        ),
        children: [
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _filter == null,
                onSelected: (_) => setState(() => _filter = null),
              ),
              for (final s in BookStatus.values)
                ChoiceChip(
                  label: Text(s.label),
                  selected: _filter == s,
                  onSelected: (_) => setState(() => _filter = s),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  books.isEmpty
                      ? 'No books yet. Add your first one.'
                      : 'No books with this status.',
                  style: text.bodySmall,
                ),
              ),
            ),
          for (final b in shown) ...[
            _BookTile(
              book: b,
              sessions: sessions.where((s) => s.bookId == b.id).toList()
                ..sort((a, c) => a.startAt.compareTo(c.startAt)),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({required this.book, required this.sessions});

  final Book book;
  final List<ReadingSession> sessions;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final status = BookStatus.parse(book.status);
    final progress = progressFraction(currentPage(sessions), book.totalPages);
    return AuraCard(
      onTap: () => context.push('/read/book/${book.id}'),
      child: Row(
        children: [
          BookCover(book: book),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: text.titleMedium),
                if (book.author.isNotEmpty)
                  Text(book.author, style: text.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    StatusPill(label: status.label, color: statusColor(status)),
                    if (book.rating != null) ...[
                      const SizedBox(width: 8),
                      RatingStars(rating: book.rating),
                    ],
                  ],
                ),
                if (progress != null && status == BookStatus.reading) ...[
                  const SizedBox(height: 8),
                  AuraProgressBar(value: progress, color: Aura.reading),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
