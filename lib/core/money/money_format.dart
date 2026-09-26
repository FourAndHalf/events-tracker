/// Formats integer minor units (cents) as e.g. "$12.50".
String formatMoney(int cents, String symbol) {
  final neg = cents < 0;
  final abs = cents.abs();
  final s = '$symbol${abs ~/ 100}.${(abs % 100).toString().padLeft(2, '0')}';
  return neg ? '-$s' : s;
}
