import 'package:events_tracker/features/reading/reading_logic.dart';
import 'package:events_tracker/features/reading/reading_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('progress is clamped and null without a page count', () {
    expect(progressFraction(50, 200), 0.25);
    expect(progressFraction(250, 200), 1.0);
    expect(progressFraction(50, null), isNull);
    expect(progressFraction(50, 0), isNull);
    expect(progressFraction(null, 200), isNull);
  });

  test('session duration uses now while running and never goes negative', () {
    final s = DateTime(2026, 1, 1, 10);
    expect(
      sessionDuration(s, DateTime(2026, 1, 1, 10, 30), DateTime(2027)),
      const Duration(minutes: 30),
    );
    expect(
      sessionDuration(s, null, DateTime(2026, 1, 1, 10, 5)),
      const Duration(minutes: 5),
    );
    expect(sessionDuration(s, null, DateTime(2026, 1, 1, 9)), Duration.zero);
  });

  test('pages read is relative to the previous end page, never negative', () {
    expect(pagesRead(40, null), 40);
    expect(pagesRead(70, 40), 30);
    expect(pagesRead(30, 40), 0);
    expect(pagesRead(null, 40), 0);
  });

  SessionStat st(DateTime d, int min, int pages) => SessionStat(
    start: d,
    duration: Duration(minutes: min),
    pages: pages,
  );

  test('time and pages are grouped by day and Monday-based week', () {
    final s = [
      st(DateTime(2026, 9, 21, 8), 20, 10), // Mon
      st(DateTime(2026, 9, 21, 21), 10, 5), // Mon
      st(DateTime(2026, 9, 27, 9), 30, 12), // Sun, same week
      st(DateTime(2026, 9, 28, 9), 15, 7), // next Mon
    ];
    expect(timePerDay(s)[DateTime(2026, 9, 21)], const Duration(minutes: 30));
    expect(pagesPerDay(s)[DateTime(2026, 9, 21)], 15);
    final w = timePerWeek(s);
    expect(w[DateTime(2026, 9, 21)], const Duration(minutes: 60));
    expect(w[DateTime(2026, 9, 28)], const Duration(minutes: 15));
  });

  test('streak counts back from today, or from yesterday if not read yet', () {
    final now = DateTime(2026, 9, 27, 12);
    final s = [
      st(DateTime(2026, 9, 27, 8), 5, 1),
      st(DateTime(2026, 9, 26, 8), 5, 1),
      st(DateTime(2026, 9, 25, 8), 5, 1),
      st(DateTime(2026, 9, 23, 8), 5, 1), // gap on the 24th
    ];
    expect(readingStreak(s, now), 3);
    expect(readingStreak(s.skip(1), now), 2); // nothing yet today
    expect(readingStreak(s.skip(3), now), 0);
    expect(readingStreak(const [], now), 0);
  });
}
