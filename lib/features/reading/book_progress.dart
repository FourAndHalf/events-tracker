import '../../core/db/app_database.dart';
import 'reading_logic.dart';
import 'reading_stats.dart';

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

/// Percent of [goal] pages that [pagesToday] reaches, clamped to 0-100.
int pageGoalPercent(int pagesToday, int goal) =>
    goal <= 0 ? 0 : (pagesToday * 100 / goal).round().clamp(0, 100);

/// Sessions reduced to time and pages for the stats. A running session counts
/// up to [now] only when [includeRunning] is set (dashboard); the stats page
/// waits until it is stopped so its page count is known.
List<SessionStat> sessionStats(
  List<ReadingSession> all,
  DateTime now, {
  bool includeRunning = false,
}) {
  final byBook = <int, List<ReadingSession>>{};
  for (final s in all) {
    byBook.putIfAbsent(s.bookId, () => []).add(s);
  }
  final out = <SessionStat>[];
  for (final sessions in byBook.values) {
    sessions.sort((a, b) => a.startAt.compareTo(b.startAt));
    final pages = pagesBySession(sessions);
    for (final s in sessions) {
      if (s.endAt == null && !includeRunning) continue;
      out.add(
        SessionStat(
          start: s.startAt,
          duration: sessionDuration(s.startAt, s.endAt, now),
          pages: pages[s.id] ?? 0,
        ),
      );
    }
  }
  return out;
}
