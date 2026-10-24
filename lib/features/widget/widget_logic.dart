enum WidgetAction { addSleep, addRead }

/// Turns a widget link like `events://add-sleep` into its action, or null
/// for anything else.
WidgetAction? parseWidgetUri(Uri? uri) {
  if (uri == null || uri.scheme != 'events') return null;
  return switch (uri.host) {
    'add-sleep' => WidgetAction.addSleep,
    'add-read' => WidgetAction.addRead,
    _ => null,
  };
}
