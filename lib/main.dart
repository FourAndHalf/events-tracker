import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/notifications/report_notifier.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/splash_overlay.dart';
import 'features/memories/reminder_scheduler.dart';
import 'features/settings/reminders_scheduler.dart';
import 'features/widget/widget_bridge.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalReportNotifier.instance.init(appRouter.go);
  runApp(const ProviderScope(child: TrackerApp()));
}

class TrackerApp extends ConsumerWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(memoryReminderSchedulerProvider);
    ref.watch(dailyReminderSchedulerProvider);
    return MaterialApp.router(
      title: 'Events',
      theme: pearlLightTheme,
      darkTheme: pearlDarkTheme,
      routerConfig: appRouter,
      builder: (context, child) =>
          WidgetLinks(child: SplashOverlay(child: child!)),
    );
  }
}
