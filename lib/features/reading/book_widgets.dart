import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import 'reading_logic.dart';

/// Cover thumbnail, or a tinted placeholder with the title's first letter.
class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.book, this.width = 48});

  final Book book;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * 1.5;
    final radius = BorderRadius.circular(8);
    final path = book.coverPath;
    Widget placeholder() => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Aura.reading.withValues(alpha: 0.18),
        borderRadius: radius,
      ),
      alignment: Alignment.center,
      child: Text(
        book.title.isEmpty ? '?' : book.title.characters.first.toUpperCase(),
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(color: Aura.reading),
      ),
    );
    if (path == null) return placeholder();
    return ClipRRect(
      borderRadius: radius,
      child: Image.file(
        File(path),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder(),
      ),
    );
  }
}

Color statusColor(BookStatus s) => switch (s) {
  BookStatus.reading => Aura.reading,
  BookStatus.finished => Aura.gain,
  BookStatus.abandoned => Aura.textMuted,
  BookStatus.wantToRead => Aura.sleep,
};

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.onChanged});

  final int? rating;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 1; i <= 5; i++)
        GestureDetector(
          onTap: onChanged == null ? null : () => onChanged!(i),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(
              i <= (rating ?? 0) ? Icons.star : Icons.star_border,
              color: Aura.moneyHi,
              size: onChanged == null ? 18 : 32,
            ),
          ),
        ),
    ],
  );
}
