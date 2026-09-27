import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/money/recurring_logic.dart';
import 'package:events_tracker/features/money/recurring_repository.dart';
import 'package:events_tracker/features/trackers/tracker_logic.dart';
import 'package:events_tracker/features/trackers/trackers_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dueDates', () {
    test('monthly from a start date, including today', () {
      final r = dueDates(
        Frequency.monthly,
        DateTime(2026, 7, 15),
        null,
        DateTime(2026, 9, 15, 20),
      );
      expect(r, [
        DateTime(2026, 7, 15),
        DateTime(2026, 8, 15),
        DateTime(2026, 9, 15),
      ]);
    });

    test('future start gives nothing; not yet due gives nothing', () {
      expect(
        dueDates(
          Frequency.monthly,
          DateTime(2026, 10, 1),
          null,
          DateTime(2026, 9, 27),
        ),
        isEmpty,
      );
      expect(
        dueDates(
          Frequency.monthly,
          DateTime(2026, 9, 1),
          DateTime(2026, 9, 1),
          DateTime(2026, 9, 27),
        ),
        isEmpty,
      );
    });

    test('continues after the last generated date (catch-up)', () {
      final r = dueDates(
        Frequency.monthly,
        DateTime(2026, 1, 5),
        DateTime(2026, 3, 5),
        DateTime(2026, 6, 10),
      );
      expect(r, [
        DateTime(2026, 4, 5),
        DateTime(2026, 5, 5),
        DateTime(2026, 6, 5),
      ]);
    });

    test('the 31st clamps to short months and returns to the 31st', () {
      final r = dueDates(
        Frequency.monthly,
        DateTime(2026, 1, 31),
        null,
        DateTime(2026, 5, 31),
      );
      expect(r, [
        DateTime(2026, 1, 31),
        DateTime(2026, 2, 28),
        DateTime(2026, 3, 31),
        DateTime(2026, 4, 30),
        DateTime(2026, 5, 31),
      ]);
      expect(
        occurrence(Frequency.monthly, DateTime(2028, 1, 31), 1),
        DateTime(2028, 2, 29),
      );
    });

    test('monthly crosses the year end', () {
      final r = dueDates(
        Frequency.monthly,
        DateTime(2026, 11, 20),
        null,
        DateTime(2027, 1, 25),
      );
      expect(r, [
        DateTime(2026, 11, 20),
        DateTime(2026, 12, 20),
        DateTime(2027, 1, 20),
      ]);
    });

    test('weekly steps by 7 days', () {
      final r = dueDates(
        Frequency.weekly,
        DateTime(2026, 9, 1),
        null,
        DateTime(2026, 9, 22),
      );
      expect(r, [
        DateTime(2026, 9, 1),
        DateTime(2026, 9, 8),
        DateTime(2026, 9, 15),
        DateTime(2026, 9, 22),
      ]);
    });

    test('yearly keeps the date, Feb 29 falls on Feb 28 in other years', () {
      expect(
        dueDates(
          Frequency.yearly,
          DateTime(2024, 2, 29),
          null,
          DateTime(2026, 12, 31),
        ),
        [DateTime(2024, 2, 29), DateTime(2025, 2, 28), DateTime(2026, 2, 28)],
      );
    });
  });

  group('generateDue', () {
    late AppDatabase db;
    late RecurringRepository repo;
    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = RecurringRepository(db);
    });
    tearDown(() => db.close());

    Future<int> rule({
      DateTime? start,
      bool active = true,
      String freq = 'monthly',
    }) => repo.add(
      RecurringExpensesCompanion.insert(
        amountCents: 1500,
        categoryId: 3,
        paymentMethod: 'Card',
        startDate: start ?? DateTime(2026, 7, 10),
        frequency: Value(freq),
        active: Value(active),
        note: const Value('Gym'),
        store: const Value('FitCo'),
      ),
    );

    test('creates the missing expenses with the rule\'s details', () async {
      await rule();
      final n = await repo.generateDue(DateTime(2026, 9, 27));
      expect(n, 3);
      final e = await (db.select(
        db.expenses,
      )..orderBy([(x) => OrderingTerm.asc(x.date)])).get();
      expect(e.map((x) => x.date), [
        DateTime(2026, 7, 10),
        DateTime(2026, 8, 10),
        DateTime(2026, 9, 10),
      ]);
      expect(e.first.amountCents, 1500);
      expect(
        (
          e.first.categoryId,
          e.first.paymentMethod,
          e.first.note,
          e.first.store,
        ),
        (3, 'Card', 'Gym', 'FitCo'),
      );
    });

    test(
      'running again the same day, or twice at once, adds nothing',
      () async {
        await rule();
        await repo.generateDue(DateTime(2026, 9, 27));
        expect(await repo.generateDue(DateTime(2026, 9, 27)), 0);
        await Future.wait([
          repo.generateDue(DateTime(2026, 10, 12)),
          repo.generateDue(DateTime(2026, 10, 12)),
        ]);
        expect(
          await db.select(db.expenses).get(),
          hasLength(4),
        ); // + 10 Oct once
      },
    );

    test('paused and future rules generate nothing', () async {
      await rule(active: false);
      await rule(start: DateTime(2026, 12, 1));
      expect(await repo.generateDue(DateTime(2026, 9, 27)), 0);
      expect(await db.select(db.expenses).get(), isEmpty);
    });

    test('resuming a paused rule catches up', () async {
      final id = await rule(active: false);
      await repo.generateDue(DateTime(2026, 9, 27));
      final r = await (db.select(
        db.recurringExpenses,
      )..where((x) => x.id.equals(id))).getSingle();
      await repo.update(r.copyWith(active: true));
      expect(await repo.generateDue(DateTime(2026, 9, 27)), 3);
    });
  });

  group('trackers repository', () {
    late AppDatabase db;
    late TrackersRepository repo;
    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = TrackersRepository(db);
    });
    tearDown(() => db.close());

    test('toggling a habit checks and unchecks the day', () async {
      final id = await repo.addTracker('Read', 'book', TrackerType.habit);
      expect(await repo.toggleHabit(id, DateTime(2026, 9, 27, 18)), isTrue);
      expect(await db.select(db.trackerEntries).get(), hasLength(1));
      expect(await repo.toggleHabit(id, DateTime(2026, 9, 27, 7)), isFalse);
      expect(await db.select(db.trackerEntries).get(), isEmpty);
    });

    test('a timer runs, persists, and stops; only one per tracker', () async {
      final id = await repo.addTracker('Guitar', 'music', TrackerType.duration);
      await repo.startTimer(id, DateTime(2026, 9, 27, 20));
      await repo.startTimer(id, DateTime(2026, 9, 27, 20, 5)); // ignored
      expect(await db.select(db.trackerEntries).get(), hasLength(1));
      final running = await repo.runningTimer(id);
      expect(running?.endAt, isNull);
      await repo.stopTimer(id, DateTime(2026, 9, 27, 20, 40));
      expect(await repo.runningTimer(id), isNull);
      final e = await db.select(db.trackerEntries).getSingle();
      expect(e.endAt, DateTime(2026, 9, 27, 20, 40));
    });

    test('deleting a tracker deletes its entries', () async {
      final a = await repo.addTracker('A', 'star', TrackerType.habit);
      final b = await repo.addTracker('B', 'star', TrackerType.habit);
      await repo.toggleHabit(a, DateTime(2026, 9, 27));
      await repo.toggleHabit(b, DateTime(2026, 9, 27));
      await repo.deleteTracker(a);
      expect((await db.select(db.trackerEntries).get()).single.trackerId, b);
    });
  });
}
