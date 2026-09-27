import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'book_widgets.dart';
import 'cover_storage.dart';
import 'reading_logic.dart';
import 'reading_repository.dart';

/// Add a book, or edit one when [id] is given.
class BookFormPage extends ConsumerStatefulWidget {
  const BookFormPage({super.key, this.id});

  final int? id;

  @override
  ConsumerState<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends ConsumerState<BookFormPage> {
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _pages = TextEditingController();
  BookStatus _status = BookStatus.wantToRead;
  int? _rating;
  String? _cover;
  // Covers picked in this visit, so a discarded pick doesn't leave a file behind.
  final _picked = <String>[];
  Book? _existing;
  bool _loaded = false;

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _pages.dispose();
    super.dispose();
  }

  void _load(Book b) {
    _existing = b;
    _title.text = b.title;
    _author.text = b.author;
    _pages.text = b.totalPages?.toString() ?? '';
    _status = BookStatus.parse(b.status);
    _rating = b.rating;
    _cover = b.coverPath;
    _loaded = true;
  }

  Future<void> _addCover(ImageSource source) async {
    final path = await pickCover(source);
    if (path == null || !mounted) return;
    _picked.add(path);
    setState(() => _cover = path);
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) return _toast('Enter a title');
    final pagesText = _pages.text.trim();
    final pages = int.tryParse(pagesText);
    if (pagesText.isNotEmpty && (pages == null || pages <= 0)) {
      return _toast('Total pages must be a whole number above 0');
    }
    final repo = ref.read(readingRepositoryProvider);
    final finished = _status == BookStatus.finished;
    final existing = _existing;
    if (existing == null) {
      await repo.addBook(
        BooksCompanion.insert(
          title: title,
          author: Value(_author.text.trim()),
          totalPages: Value(pages),
          status: Value(_status.name),
          rating: Value(finished ? _rating : null),
          coverPath: Value(_cover),
          finishedAt: Value(finished ? DateTime.now() : null),
        ),
      );
    } else {
      await repo.updateBook(
        existing.copyWith(
          title: title,
          author: _author.text.trim(),
          totalPages: Value(pages),
          status: _status.name,
          rating: Value(finished ? _rating : existing.rating),
          coverPath: Value(_cover),
          finishedAt: Value(
            !finished
                ? null
                : (existing.status == BookStatus.finished.name
                      ? existing.finishedAt
                      : DateTime.now()),
          ),
        ),
      );
    }
    // Drop covers that are no longer used: unsaved picks and a replaced cover.
    for (final p in _picked.where((p) => p != _cover)) {
      await deleteCover(p);
    }
    if (existing != null && existing.coverPath != _cover) {
      await deleteCover(existing.coverPath);
    }
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final b = _existing!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this book?'),
        content: const Text('Its reading sessions and notes are deleted too.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final cover = await ref.read(readingRepositoryProvider).deleteBook(b);
    await deleteCover(cover);
    if (mounted) context.go('/read');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null && !_loaded) {
      final b = (ref.watch(booksProvider).value ?? const <Book>[])
          .where((b) => b.id == widget.id)
          .firstOrNull;
      if (b == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Edit book')),
          body: const SizedBox.shrink(),
        );
      }
      _load(b);
    }
    final preview = Book(
      id: 0,
      title: _title.text,
      author: '',
      status: _status.name,
      coverPath: _cover,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add book' : 'Edit book'),
        actions: [
          if (widget.id != null)
            IconButton(
              tooltip: 'Delete',
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          Row(
            children: [
              BookCover(book: preview, width: 72),
              const SizedBox(width: 16),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PillButton(
                      label: 'Camera',
                      icon: Icons.photo_camera_outlined,
                      ghost: true,
                      onPressed: () => _addCover(ImageSource.camera),
                    ),
                    PillButton(
                      label: 'Gallery',
                      icon: Icons.photo_outlined,
                      ghost: true,
                      onPressed: () => _addCover(ImageSource.gallery),
                    ),
                    if (_cover != null)
                      PillButton(
                        label: 'Remove',
                        ghost: true,
                        onPressed: () => setState(() => _cover = null),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Title'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _author,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Author'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pages,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Total pages'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final s in BookStatus.values)
                ChoiceChip(
                  label: Text(s.label),
                  selected: _status == s,
                  onSelected: (_) => setState(() => _status = s),
                ),
            ],
          ),
          if (_status == BookStatus.finished) ...[
            const SizedBox(height: 16),
            const Overline('Rating'),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: RatingStars(
                rating: _rating,
                onChanged: (v) => setState(() => _rating = v),
              ),
            ),
          ],
          const SizedBox(height: 24),
          PillButton(label: 'Save', color: Aura.reading, onPressed: _save),
        ],
      ),
    );
  }
}
