import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import 'book_widgets.dart';
import 'reading_logic.dart';
import 'reading_repository.dart';

/// Asks for a 1-5 rating. Returns null if dismissed.
Future<int?> askRating(BuildContext context, {int? initial}) {
  var value = initial;
  return showDialog<int>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('How was it?'),
        content: RatingStars(
          rating: value,
          onChanged: (v) => setState(() => value = v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Skip'),
          ),
          TextButton(
            onPressed: value == null ? null : () => Navigator.pop(ctx, value),
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

/// Marks [book] finished, asking for a rating first.
Future<void> finishBook(BuildContext context, WidgetRef ref, Book book) async {
  final rating = await askRating(context, initial: book.rating);
  await ref
      .read(readingRepositoryProvider)
      .setStatus(book, BookStatus.finished, rating: rating);
}

/// Stops the running [session]: asks for the page reached and an optional note.
/// Offers to finish the book when the last page is reached.
Future<void> stopSessionFlow(
  BuildContext context,
  WidgetRef ref,
  ReadingSession session,
  Book book,
) async {
  final page = TextEditingController();
  final note = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Stop reading'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: page,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Page you reached',
              helperText: book.totalPages == null
                  ? null
                  : 'of ${book.totalPages}',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: note,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Note (optional)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Keep reading'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Stop'),
        ),
      ],
    ),
  );
  final endPage = int.tryParse(page.text.trim());
  final noteText = note.text.trim();
  page.dispose();
  note.dispose();
  if (ok != true) return;
  final repo = ref.read(readingRepositoryProvider);
  await repo.stopSession(session.id, DateTime.now(), endPage: endPage);
  if (noteText.isNotEmpty) {
    await repo.addNote(book.id, noteText, sessionId: session.id);
  }
  if (!context.mounted) return;
  final total = book.totalPages;
  if (endPage != null &&
      total != null &&
      endPage >= total &&
      book.status != BookStatus.finished.name) {
    final done = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finished the book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not yet'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (done == true && context.mounted) await finishBook(context, ref, book);
  }
}

/// Starts the timer, or explains why it can't.
Future<void> startSessionFlow(
  BuildContext context,
  WidgetRef ref,
  Book book,
) async {
  try {
    await ref
        .read(readingRepositoryProvider)
        .startSession(book.id, DateTime.now());
  } on TimerAlreadyRunningException {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stop the running timer first')),
    );
  }
}
