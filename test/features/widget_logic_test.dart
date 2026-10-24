import 'package:events_tracker/features/widget/widget_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('widget links map to actions', () {
    expect(
      parseWidgetUri(Uri.parse('events://add-sleep')),
      WidgetAction.addSleep,
    );
    expect(
      parseWidgetUri(Uri.parse('events://add-read')),
      WidgetAction.addRead,
    );
  });

  test('anything else is ignored', () {
    expect(parseWidgetUri(null), isNull);
    expect(parseWidgetUri(Uri.parse('events://unknown')), isNull);
    expect(parseWidgetUri(Uri.parse('https://add-sleep')), isNull);
    expect(parseWidgetUri(Uri.parse('/sleep')), isNull);
  });
}
