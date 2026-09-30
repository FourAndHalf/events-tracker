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
