import '../../core/db/app_database.dart';
import 'reading_logic.dart';

/// Pages read per session id. [ascending] must be sorted oldest first and
/// contain one book's sessions; each is measured from the previous end page.
Map<int, int> pagesBySession(List<ReadingSession> ascending) {
  final out = <int, int>{};
  int? previous;
  for (final s in ascending) {
    if (s.endAt == null) continue; // still running
    out[s.id] = pagesRead(s.endPage, previous);
    if (s.endPage != null) previous = s.endPage;
  }
  return out;
}

/// The page a book is up to: the end page of its most recent session that has one.
int? currentPage(List<ReadingSession> ascending) {
  for (final s in ascending.reversed) {
    if (s.endPage != null) return s.endPage;
  }
  return null;
}
