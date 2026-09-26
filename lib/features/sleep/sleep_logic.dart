/// Time asleep. Works across midnight because it uses full DateTimes.
Duration sleepDuration(DateTime sleepAt, DateTime wakeAt) =>
    wakeAt.difference(sleepAt);

/// Minutes after midnight for [t].
int minutesOfDay(DateTime t) => t.hour * 60 + t.minute;

/// Puts after-midnight bedtimes (before noon) after evening ones so they compare correctly.
int _bedtimeOrder(int minutesOfDay) =>
    minutesOfDay < 720 ? minutesOfDay + 1440 : minutesOfDay;

/// True if [bedtime] is at or before [targetBedtimeMinutes] (minutes after midnight).
bool bedtimeOnTime(DateTime bedtime, int targetBedtimeMinutes) =>
    _bedtimeOrder(minutesOfDay(bedtime)) <= _bedtimeOrder(targetBedtimeMinutes);

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
