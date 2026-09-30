import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/sleep/sleep_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sleepDuration', () {
    test('same day', () {
      expect(
        sleepDuration(DateTime(2026, 1, 1, 1, 0), DateTime(2026, 1, 1, 8, 30)),
        const Duration(hours: 7, minutes: 30),
      );
    });
    test('across midnight', () {
      expect(
        sleepDuration(
          DateTime(2026, 1, 1, 23, 15),
          DateTime(2026, 1, 2, 6, 45),
        ),
        const Duration(hours: 7, minutes: 30),
      );
    });
    test('across month boundary', () {
      expect(
        sleepDuration(DateTime(2026, 1, 31, 22, 0), DateTime(2026, 2, 1, 6, 0)),
        const Duration(hours: 8),
      );
    });
  });

  group('hitGoal (goal 8h, target 23:00)', () {
    bool hit(DateTime sleep, DateTime wake) => hitGoal(
      sleepAt: sleep,
      wakeAt: wake,
      goalMinutes: 480,
      targetBedtimeMinutes: 23 * 60,
    );
    test('hit: on time and long enough', () {
      expect(
        hit(DateTime(2026, 1, 1, 22, 45), DateTime(2026, 1, 2, 7, 0)),
        isTrue,
      );
    });
    test('miss: too short', () {
      expect(
        hit(DateTime(2026, 1, 1, 22, 45), DateTime(2026, 1, 2, 5, 0)),
        isFalse,
      );
    });
    test('miss: bedtime after midnight is later than 23:00', () {
      expect(
        hit(DateTime(2026, 1, 2, 0, 30), DateTime(2026, 1, 2, 9, 0)),
        isFalse,
      );
    });
    test('hit: exactly at target and exactly the goal', () {
      expect(
        hit(DateTime(2026, 1, 1, 23, 0), DateTime(2026, 1, 2, 7, 0)),
        isTrue,
      );
    });
  });

  test('formatDuration', () {
    expect(formatDuration(const Duration(hours: 7, minutes: 5)), '7h 05m');
  });

  group('sleepToday', () {
    final now = DateTime(2026, 1, 2, 12, 0);
    SleepSession session(DateTime sleepAt, DateTime? wakeAt) =>
        SleepSession(id: 1, sleepAt: sleepAt, wakeAt: wakeAt, quality: null, note: null);

    test('sums sessions that woke today, ignores others', () {
      final sessions = [
        session(DateTime(2026, 1, 1, 23, 0), DateTime(2026, 1, 2, 7, 0)), // today
        session(DateTime(2026, 1, 1, 13, 0), DateTime(2026, 1, 1, 14, 0)), // yesterday
        session(DateTime(2026, 1, 2, 12, 30), null), // still open
      ];
      expect(sleepToday(sessions, now), const Duration(hours: 8));
    });

    test('no sessions today gives zero', () {
      expect(sleepToday(const [], now), Duration.zero);
    });
  });

  group('sleepGoalPercent', () {
    test('percent of goal, clamped to 100', () {
      expect(sleepGoalPercent(const Duration(hours: 4), 480), 50);
      expect(sleepGoalPercent(const Duration(hours: 10), 480), 100);
    });
    test('zero goal is zero percent', () {
      expect(sleepGoalPercent(const Duration(hours: 4), 0), 0);
    });
  });
}
