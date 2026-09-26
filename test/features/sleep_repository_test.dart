import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/sleep/sleep_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late SleepRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SleepRepository(db);
  });
  tearDown(() => db.close());

  test('only one open session at a time', () async {
    await repo.start(DateTime(2026, 1, 1, 23));
    await repo.start(DateTime(2026, 1, 1, 23, 5));
    expect((await repo.watchAll().first).length, 1);
  });

  test('wake closes the session and quality is saved', () async {
    await repo.start(DateTime(2026, 1, 1, 23));
    final open = (await repo.watchOpen().first)!;
    await repo.wake(open.id, DateTime(2026, 1, 2, 7));
    await repo.setQuality(open.id, 4, 'ok');
    expect(await repo.watchOpen().first, isNull);
    final last = (await repo.watchLastCompleted().first)!;
    expect(last.quality, 4);
    expect(last.wakeAt, DateTime(2026, 1, 2, 7));
  });

  test('database seeds settings and default categories', () async {
    expect((await db.select(db.settings).get()).single.sleepGoalMinutes, 480);
    expect(
      (await db.select(db.categories).get()).length,
      defaultCategories.length,
    );
  });
}
