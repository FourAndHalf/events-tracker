import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/router/app_router.dart';
import 'package:events_tracker/features/trackers/tracker_logic.dart';
import 'package:events_tracker/features/trackers/trackers_repository.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _boot(
  WidgetTester tester,
  AppDatabase db, {
  String at = '/',
}) async {
  appRouter.go(at);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const TrackerApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 2));
  await _settle(tester);
}

Future<void> _close(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets(
    'dashboard quick-taps check off a habit; a timer survives a restart',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      await tester.runAsync(() async {
        final repo = TrackersRepository(db);
        final h = await repo.addTracker(
          'Meditate',
          'meditate',
          TrackerType.habit,
        );
        // Two earlier days, so checking today makes a 3-day streak.
        final now = DateTime.now();
        await repo.toggleHabit(h, DateTime(now.year, now.month, now.day - 1));
        await repo.toggleHabit(h, DateTime(now.year, now.month, now.day - 2));
        await repo.addTracker('Guitar', 'music', TrackerType.duration);
      });

      await _boot(tester, db);
      await tester.scrollUntilVisible(
        find.text('Meditate'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('2 day streak'), findsOneWidget);
      await tester.ensureVisible(find.byTooltip('Check off Meditate'));
      await tester.pump();
      await tester.tap(find.byTooltip('Check off Meditate'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      expect(find.text('3 day streak'), findsOneWidget);
      expect(find.byTooltip('Uncheck Meditate'), findsOneWidget);

      await tester.ensureVisible(find.byTooltip('Start Guitar'));
      await tester.pump();
      await tester.tap(find.byTooltip('Start Guitar'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      expect(find.byTooltip('Stop Guitar'), findsOneWidget);

      // "Kill the app" and reopen on the same database: still running.
      await _close(tester);
      await _boot(tester, db);
      await tester.scrollUntilVisible(
        find.text('Guitar'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byTooltip('Stop Guitar'), findsOneWidget);

      await tester.ensureVisible(find.byTooltip('Stop Guitar'));
      await tester.pump();
      await tester.tap(find.byTooltip('Stop Guitar'));
      await tester.pump(const Duration(milliseconds: 300));
      await _settle(tester);
      expect(find.byTooltip('Start Guitar'), findsOneWidget);
      final entries = await tester.runAsync(
        () => db.select(db.trackerEntries).get(),
      );
      expect(
        entries!.where((e) => e.startAt != null && e.endAt != null),
        hasLength(1),
      );

      await _close(tester);
      await tester.runAsync(db.close);
    },
  );

  testWidgets('create a tracker from the form and see it listed', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => db.select(db.trackers).get());
    await _boot(tester, db, at: '/trackers');
    await tester.tap(find.text('Tracker'));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Save'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Enter a name'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Drink water');
    await tester.tap(find.text('Save'));
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);
    expect(find.text('Drink water'), findsOneWidget);
    expect(find.text('No streak yet'), findsOneWidget);

    await _close(tester);
    await tester.runAsync(db.close);
  });
}
