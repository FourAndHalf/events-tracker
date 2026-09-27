import 'package:intl/intl.dart';

enum WidgetAction { sleepToggle, readToggle, addExpense }

/// Turns a widget link like `events://sleep-toggle` into its action, or null
/// for anything else.
WidgetAction? parseWidgetUri(Uri? uri) {
  if (uri == null || uri.scheme != 'events') return null;
  return switch (uri.host) {
    'sleep-toggle' => WidgetAction.sleepToggle,
    'read-toggle' => WidgetAction.readToggle,
    'add-expense' => WidgetAction.addExpense,
    _ => null,
  };
}

/// Text under the Sleep button: since when you have been asleep, or a prompt.
String sleepWidgetLabel(DateTime? asleepSince) => asleepSince == null
    ? 'Tap to sleep'
    : 'Asleep since ${DateFormat.jm().format(asleepSince)}';

/// Text under the Read button: the book being read, or a prompt.
String readWidgetLabel(String? runningTitle) =>
    runningTitle == null ? 'Tap to start' : 'Reading: $runningTitle';
