import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/pearl_widgets.dart';
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
          PearlIconButton(
            tooltip: 'Charts',
            onPressed: () => context.push('/read/charts'),
            icon: Icons.bar_chart,
          ),
          const SizedBox(width: 8),
          PearlIconButton(
            tooltip: 'Stats',
            onPressed: () => context.push('/read/stats'),
            icon: Icons.insights_outlined,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add book',
        onPressed: () => context.push('/read/edit'),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Pearl.margin,
          Pearl.margin,
          Pearl.margin,
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
            const SizedBox(height: Pearl.gutter),
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
    return Module(
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
                    StatusBadge(label: status.label, tone: statusTone(status)),
                    if (book.rating != null) ...[
                      const SizedBox(width: 8),
                      RatingStars(rating: book.rating),
                    ],
                  ],
                ),
                if (progress != null && status == BookStatus.reading) ...[
                  const SizedBox(height: 8),
                  Meter(value: progress),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
