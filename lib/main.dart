import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/splash_overlay.dart';

void main() {
  runApp(const ProviderScope(child: TrackerApp()));
}

class TrackerApp extends StatelessWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Events',
      theme: auraTheme,
      routerConfig: appRouter,
      builder: (context, child) => SplashOverlay(child: child!),
    );
  }
}
