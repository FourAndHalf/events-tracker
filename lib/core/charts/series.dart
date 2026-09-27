import 'package:intl/intl.dart';

class ChartBar {
  const ChartBar(this.label, this.value, {this.color});

  final String label;
  final double value;
  final Object? color; // Color, kept untyped so this file stays UI-free
}

class ChartPoint {
  const ChartPoint(this.label, this.value);

  final String label;
  final double value;
}

DateTime dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

/// The last [days] calendar days ending today, oldest first.
List<DateTime> lastDays(int days, DateTime today) {
  final t = dayStart(today);
  return [
    for (var i = days - 1; i >= 0; i--) DateTime(t.year, t.month, t.day - i),
  ];
}

/// Axis label for a day: weekday letters for a week, day numbers (every 5th)
/// for a longer range so labels don't crowd.
String dayLabel(DateTime d, int rangeDays) {
  if (rangeDays <= 7) return DateFormat('E').format(d).substring(0, 2);
  return d.day == 1 || d.day % 5 == 0 ? '${d.day}' : '';
}

/// Monday 00:00 of the week containing [d].
DateTime mondayOf(DateTime d) =>
    DateTime(d.year, d.month, d.day - (d.weekday - DateTime.monday));

/// The last [weeks] Mondays ending with this week, oldest first.
List<DateTime> lastWeeks(int weeks, DateTime today) {
  final m = mondayOf(today);
  return [
    for (var i = weeks - 1; i >= 0; i--)
      DateTime(m.year, m.month, m.day - 7 * i),
  ];
}

/// The last [months] first-of-months ending with this month, oldest first.
List<DateTime> lastMonths(int months, DateTime today) => [
  for (var i = months - 1; i >= 0; i--) DateTime(today.year, today.month - i),
];
