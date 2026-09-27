import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/reading/book_progress.dart';
import 'package:flutter_test/flutter_test.dart';

ReadingSession _s(int id, int day, int? page, {bool open = false}) =>
    ReadingSession(
      id: id,
      bookId: 1,
      startAt: DateTime(2026, 9, day, 20),
      endAt: open ? null : DateTime(2026, 9, day, 21),
      endPage: page,
    );

void main() {
  test('pages per session are relative to the previous end page', () {
    final s = [_s(1, 1, 30), _s(2, 2, null), _s(3, 3, 55), _s(4, 4, 50)];
    expect(pagesBySession(s), {1: 30, 2: 0, 3: 25, 4: 0});
  });

  test('running sessions are skipped; current page is the latest end page', () {
    final s = [_s(1, 1, 30), _s(2, 2, null, open: true)];
    expect(pagesBySession(s).containsKey(2), isFalse);
    expect(currentPage(s), 30);
    expect(currentPage(const []), isNull);
  });
}
