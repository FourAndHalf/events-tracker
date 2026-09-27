import 'package:events_tracker/features/widget/widget_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('widget links map to actions', () {
    expect(
      parseWidgetUri(Uri.parse('events://sleep-toggle')),
      WidgetAction.sleepToggle,
    );
    expect(
      parseWidgetUri(Uri.parse('events://read-toggle')),
      WidgetAction.readToggle,
    );
    expect(
      parseWidgetUri(Uri.parse('events://add-expense')),
      WidgetAction.addExpense,
    );
  });

  test('anything else is ignored', () {
    expect(parseWidgetUri(null), isNull);
    expect(parseWidgetUri(Uri.parse('events://unknown')), isNull);
    expect(parseWidgetUri(Uri.parse('https://sleep-toggle')), isNull);
    expect(parseWidgetUri(Uri.parse('/sleep')), isNull);
  });

  test('labels reflect state', () {
    expect(sleepWidgetLabel(null), 'Tap to sleep');
    expect(sleepWidgetLabel(DateTime(2026, 9, 27, 23, 5)), contains('11:05'));
    expect(readWidgetLabel(null), 'Tap to start');
    expect(readWidgetLabel('Dune'), 'Reading: Dune');
  });
}
