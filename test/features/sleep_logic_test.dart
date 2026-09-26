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
}
