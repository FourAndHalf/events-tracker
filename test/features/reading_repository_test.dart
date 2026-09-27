import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:events_tracker/core/db/app_database.dart';
import 'package:events_tracker/features/reading/reading_logic.dart';
import 'package:events_tracker/features/reading/reading_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ReadingRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ReadingRepository(db);
  });
  tearDown(() => db.close());

  Future<Book> book() async {
    final id = await repo.addBook(
      BooksCompanion.insert(title: 'Dune', author: const Value('Herbert')),
    );
    return (db.select(db.books)..where((b) => b.id.equals(id))).getSingle();
  }

  test(
    'starting a timer flips want-to-read to reading and persists it',
    () async {
      final b = await book();
      expect(b.status, 'wantToRead');
      final id = await repo.startSession(b.id, DateTime(2026, 9, 27, 10));
      final running = await repo.runningSession();
      expect(running?.id, id);
      expect(running?.endAt, isNull);
      final after = await (db.select(db.books)).getSingle();
      expect(after.status, 'reading');
    },
  );

  test('only one timer can run at a time', () async {
    final b = await book();
    await repo.startSession(b.id, DateTime(2026, 9, 27, 10));
    expect(
      () => repo.startSession(b.id, DateTime(2026, 9, 27, 11)),
      throwsA(isA<TimerAlreadyRunningException>()),
    );
  });

  test('stopping records end time and page, and frees the timer', () async {
    final b = await book();
    final id = await repo.startSession(b.id, DateTime(2026, 9, 27, 10));
    await repo.stopSession(id, DateTime(2026, 9, 27, 10, 45), endPage: 60);
    expect(await repo.runningSession(), isNull);
    final s = await db.select(db.readingSessions).getSingle();
    expect(s.endPage, 60);
    expect(s.endAt, DateTime(2026, 9, 27, 10, 45));
  });

  test('finishing sets rating and date; reopening clears the date', () async {
    final b = await book();
    await repo.setStatus(b, BookStatus.finished, rating: 4);
    var got = await db.select(db.books).getSingle();
    expect(got.rating, 4);
    expect(got.finishedAt, isNotNull);
    await repo.setStatus(got, BookStatus.reading);
    got = await db.select(db.books).getSingle();
    expect(got.finishedAt, isNull);
    expect(got.rating, 4);
  });

  test('deleting a session keeps its notes, unlinked', () async {
    final b = await book();
    final sid = await repo.startSession(b.id, DateTime(2026, 9, 27, 10));
    await repo.addNote(b.id, ' great line ', sessionId: sid, isQuote: true);
    await repo.deleteSession(sid);
    final n = await db.select(db.readingNotes).getSingle();
    expect(n.body, 'great line');
    expect(n.isQuote, isTrue);
    expect(n.sessionId, isNull);
  });

  test(
    'deleting a book removes its sessions and notes, returns cover',
    () async {
      final id = await repo.addBook(
        BooksCompanion.insert(title: 'X', coverPath: const Value('/c.jpg')),
      );
      final b = await (db.select(
        db.books,
      )..where((x) => x.id.equals(id))).getSingle();
      final sid = await repo.startSession(id, DateTime(2026, 9, 27, 10));
      await repo.addNote(id, 'n', sessionId: sid);
      expect(await repo.deleteBook(b), '/c.jpg');
      expect(await db.select(db.books).get(), isEmpty);
      expect(await db.select(db.readingSessions).get(), isEmpty);
      expect(await db.select(db.readingNotes).get(), isEmpty);
    },
  );
}
