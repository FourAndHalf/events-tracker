import '../../core/db/app_database.dart';

/// Time asleep. Works across midnight because it uses full DateTimes.
Duration sleepDuration(DateTime sleepAt, DateTime wakeAt) =>
    wakeAt.difference(sleepAt);

/// Minutes after midnight for [t].
int minutesOfDay(DateTime t) => t.hour * 60 + t.minute;

/// Puts after-midnight bedtimes (before noon) after evening ones so they compare correctly.
int bedtimeOrder(int minutesOfDay) =>
    minutesOfDay < 720 ? minutesOfDay + 1440 : minutesOfDay;

/// True if [bedtime] is at or before [targetBedtimeMinutes] (minutes after midnight).
bool bedtimeOnTime(DateTime bedtime, int targetBedtimeMinutes) =>
    bedtimeOrder(minutesOfDay(bedtime)) <= bedtimeOrder(targetBedtimeMinutes);

/// A night is a hit when it meets the sleep goal AND the target bedtime.
bool hitGoal({
  required DateTime sleepAt,
  required DateTime wakeAt,
  required int goalMinutes,
  required int targetBedtimeMinutes,
}) =>
    sleepDuration(sleepAt, wakeAt).inMinutes >= goalMinutes &&
    bedtimeOnTime(sleepAt, targetBedtimeMinutes);

/// "7h 40m" style text.
String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  return '${h}h ${m.toString().padLeft(2, '0')}m';
}

/// Total time asleep across sessions that ended (woke) today.
Duration sleepToday(Iterable<SleepSession> sessions, DateTime now) {
  var total = Duration.zero;
  for (final s in sessions) {
    final wakeAt = s.wakeAt;
    if (wakeAt != null &&
        wakeAt.year == now.year &&
        wakeAt.month == now.month &&
        wakeAt.day == now.day) {
      total += sleepDuration(s.sleepAt, wakeAt);
    }
  }
  return total;
}

/// Percent of [goalMinutes] that [total] reaches, clamped to 0-100.
int sleepGoalPercent(Duration total, int goalMinutes) =>
    goalMinutes <= 0 ? 0 : (total.inMinutes * 100 / goalMinutes).round().clamp(0, 100);
