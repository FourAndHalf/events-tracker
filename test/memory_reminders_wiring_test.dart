import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/core/db/providers.dart';
import 'package:events_tracker/core/notifications/report_notifier.dart';
import 'package:events_tracker/features/memories/memories_repository.dart';
import 'package:events_tracker/features/memories/reminder_plan.dart';
import 'package:events_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotifier implements ReportNotifier {
  final scheduled =
      <({int id, DateTime when, String title, String body, String route})>[];
  final cancelledRanges = <(int, int)>[];
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
  }) async => scheduled.add((
    id: id,
    when: when,
    title: title,
    body: body,
    route: route,
  ));
  final daily =
      <({int id, int minutes, String title, String body, String route})>[];
  @override
  Future<void> scheduleDaily({
    required int id,
    required int minutes,
    required String title,
    required String body,
    required String route,
  }) async => daily.add((
    id: id,
    minutes: minutes,
    title: title,
    body: body,
    route: route,
  ));
  @override
  Future<void> cancelRange(int from, int to) async =>
      cancelledRanges.add((from, to));
}

Future<void> _boot(WidgetTester tester, AppDatabase db, FakeNotifier n) async {
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
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('reminders follow events: added, edited, deleted', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => db.select(db.memoryEvents).get());
    final n = FakeNotifier();
    await _boot(tester, db, n);
    final repo = MemoriesRepository(db);
    final soon = DateTime.now().add(const Duration(days: 10));

    final id = (await tester.runAsync(
      () => repo.addEvent(
        MemoryEventsCompanion.insert(
          title: 'Mum birthday',
          categoryId: 1,
          createdAt: DateTime.now(),
          kind: const Value('occasion'),
          month: Value(soon.month),
          day: Value(soon.day),
          remindOnDay: const Value(true),
        ),
      ),
    ))!;
    await _settle(tester);
    expect(n.scheduled.map((r) => r.title), contains('Mum birthday'));
    final mine = n.scheduled.where((r) => r.title == 'Mum birthday').last;
    expect(mine.route, '/memories/event/$id');
    expect(mine.id, greaterThanOrEqualTo(reminderIdBase));
    expect(n.cancelledRanges.last, (reminderIdBase, reminderIdEnd));

    // Deleting the event clears the range and schedules nothing for it.
    final before = n.scheduled.length;
    await tester.runAsync(() => repo.deleteEvent(id));
    await _settle(tester);
    expect(n.scheduled.length, before);
    expect(n.cancelledRanges.length, greaterThan(1));

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(db.close);
  });
}
