import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/db/settings_repository.dart';
import 'package:events_tracker/core/notifications/report_notifier.dart';
import 'package:events_tracker/core/router/app_router.dart';
import 'package:events_tracker/features/trackers/tracker_logic.dart';
import 'package:events_tracker/features/trackers/trackers_repository.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotifier implements ReportNotifier {
  final daily = <({int id, int minutes, String route})>[];
  final cancelled = <(int, int)>[];
  @override
  Future<void> schedule(DateTime when, String title, String body) async {}
  @override
  Future<void> cancel() async {}
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required String route,
  }) async {}
  @override
  Future<void> scheduleDaily({
    required int id,
    required int minutes,
    required String title,
    required String body,
    required String route,
  }) async => daily.add((id: id, minutes: minutes, route: route));
  @override
  Future<void> cancelRange(int from, int to) async {
    cancelled.add((from, to));
  }
}

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('daily reminders are scheduled from settings and trackers', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() async {
      await updateSettings(
        db,
        const SettingsCompanion(
          bedtimeReminderEnabled: Value(true),
          expenseReminderEnabled: Value(true),
        ),
      );
      final repo = TrackersRepository(db);
      final id = await repo.addTracker('Meditate', 'star', TrackerType.habit);
      final t = await (db.select(
        db.trackers,
      )..where((x) => x.id.equals(id))).getSingle();
      await repo.updateTracker(t.copyWith(reminderMinutes: const Value(480)));
    });
    final n = FakeNotifier();
    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          reportNotifierProvider.overrideWithValue(n),
        ],
        child: const TrackerApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    await _settle(tester);
    await _settle(tester);

    expect(n.daily.map((r) => r.id).toSet(), {10, 11, 101});
    expect(
      n.daily.firstWhere((r) => r.id == 10).minutes,
      1350,
    ); // 23:00 - 30 min
    expect(n.daily.firstWhere((r) => r.id == 11).route, '/money/add');
    expect(n.daily.firstWhere((r) => r.id == 101).route, '/trackers/1');
    expect(n.cancelled, isNotEmpty);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(db.close);
  });

  testWidgets('reminders page toggles the bedtime reminder', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => db.select(db.settings).get());
    appRouter.go('/settings/reminders');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          reportNotifierProvider.overrideWithValue(FakeNotifier()),
        ],
        child: const TrackerApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    await _settle(tester);
    await tester.tap(find.text('Bedtime reminder'));
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);
    expect(find.text('30 min before'), findsOneWidget);
    expect(find.textContaining('Every day at'), findsOneWidget);
    final s = await tester.runAsync(() => (db.select(db.settings)).getSingle());
    expect(s!.bedtimeReminderEnabled, isTrue);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(db.close);
  });
}
