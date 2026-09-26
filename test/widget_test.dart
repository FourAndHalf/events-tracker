import 'package:events_tracker/core/money/money_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatMoney formats cents', () {
    expect(formatMoney(1250, r'$'), r'$12.50');
    expect(formatMoney(5, r'$'), r'$0.05');
    expect(formatMoney(-1999, '€'), '-€19.99');
  });
}
