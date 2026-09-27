import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/notifications/report_notifier.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/splash_overlay.dart';
import 'features/investing/report_scheduler.dart';
import 'features/memories/reminder_scheduler.dart';
import 'features/money/recurring_repository.dart';
import 'features/settings/reminders_scheduler.dart';
import 'features/widget/widget_bridge.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final launchRoute = await LocalReportNotifier.instance.init(appRouter.go);
  runApp(const ProviderScope(child: TrackerApp()));
  if (launchRoute != null) {
    // Opened by tapping a notification.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => appRouter.go(launchRoute),
    );
  }
}

class TrackerApp extends ConsumerWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(snapshotWriterProvider);
    ref.watch(reportSchedulerProvider);
    ref.watch(memoryReminderSchedulerProvider);
    ref.watch(recurringGeneratorProvider);
    ref.watch(dailyReminderSchedulerProvider);
    ref.watch(widgetSyncProvider);
    return MaterialApp.router(
      title: 'Events',
      theme: auraTheme,
      routerConfig: appRouter,
      builder: (context, child) =>
          WidgetLinks(child: SplashOverlay(child: child!)),
    );
  }
}
