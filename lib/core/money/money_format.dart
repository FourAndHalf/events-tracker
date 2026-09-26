/// Formats integer minor units (cents) as e.g. "$12.50".
String formatMoney(int cents, String symbol) {
  final neg = cents < 0;
  final abs = cents.abs();
  final s = '$symbol${abs ~/ 100}.${(abs % 100).toString().padLeft(2, '0')}';
  return neg ? '-$s' : s;
}

/// Parses user input like "12", "12.5" or "12.50" into cents. Returns null if invalid or not positive.
int? parseCents(String input) {
  final m = RegExp(r'^(\d+)(?:[.,](\d{1,2}))?$').firstMatch(input.trim());
  if (m == null) return null;
  final cents =
      int.parse(m.group(1)!) * 100 +
      int.parse((m.group(2) ?? '').padRight(2, '0'));
  return cents > 0 ? cents : null;
}
