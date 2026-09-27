enum BookStatus {
  wantToRead('Want to read'),
  reading('Reading'),
  finished('Finished'),
  abandoned('Abandoned');

  const BookStatus(this.label);
  final String label;

  static BookStatus parse(String name) => values.firstWhere(
    (s) => s.name == name,
    orElse: () => BookStatus.wantToRead,
  );
}

/// Reading progress as 0..1, or null when the book has no page count.
double? progressFraction(int? endPage, int? totalPages) {
  if (endPage == null || totalPages == null || totalPages <= 0) return null;
  return (endPage / totalPages).clamp(0.0, 1.0);
}

Duration sessionDuration(DateTime start, DateTime? end, DateTime now) {
  final d = (end ?? now).difference(start);
  return d.isNegative ? Duration.zero : d;
}

/// Pages read in a session: its end page minus where the previous session
/// ended (0 for the first). Never negative, so re-reading doesn't subtract.
int pagesRead(int? endPage, int? previousEndPage) {
  if (endPage == null) return 0;
  final read = endPage - (previousEndPage ?? 0);
  return read < 0 ? 0 : read;
}
