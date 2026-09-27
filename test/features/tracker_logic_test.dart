import 'package:events_tracker/features/trackers/tracker_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 9, 27, 15);
  DateTime d(int day, [int month = 9]) => DateTime(2026, month, day, 8);

  group('currentStreak', () {
    test('counts back from today', () {
      expect(currentStreak([d(27), d(26), d(25)], now), 3);
    });

    test('still alive when today is not checked yet', () {
      expect(currentStreak([d(26), d(25)], now), 2);
    });

    test('a missed day breaks it', () {
      expect(currentStreak([d(27), d(25), d(24)], now), 1);
      expect(currentStreak([d(25), d(24)], now), 0);
    });

    test('empty, duplicates and time of day are ignored', () {
      expect(currentStreak(const [], now), 0);
      expect(
        currentStreak([
          DateTime(2026, 9, 27, 1),
          DateTime(2026, 9, 27, 23),
        ], now),
        1,
      );
    });

    test('runs across month and year boundaries', () {
      final n = DateTime(2027, 1, 2);
      expect(
        currentStreak([
          DateTime(2027, 1, 2),
          DateTime(2027, 1, 1),
          DateTime(2026, 12, 31),
          DateTime(2026, 12, 30),
        ], n),
        4,
      );
    });

    test('runs across a leap day', () {
      final n = DateTime(2028, 3, 1);
      expect(
        currentStreak([
          DateTime(2028, 3, 1),
          DateTime(2028, 2, 29),
          DateTime(2028, 2, 28),
        ], n),
        3,
      );
    });
  });

  group('bestStreak', () {
    test('finds the longest run, not the current one', () {
      expect(bestStreak([d(1), d(2), d(3), d(4), d(10), d(11)]), 4);
    });

    test('single days, empty and duplicates', () {
      expect(bestStreak([d(1), d(5), d(9)]), 1);
      expect(bestStreak(const []), 0);
      expect(bestStreak([d(1), d(1), d(2)]), 2);
    });
  });

  test('entry duration uses now while running and never goes negative', () {
    final s = DateTime(2026, 9, 27, 10);
    expect(
      entryDuration(s, DateTime(2026, 9, 27, 10, 30), now),
      const Duration(minutes: 30),
    );
    expect(
      entryDuration(s, null, DateTime(2026, 9, 27, 10, 5)),
      const Duration(minutes: 5),
    );
    expect(entryDuration(s, null, DateTime(2026, 9, 27, 9)), Duration.zero);
  });
}
