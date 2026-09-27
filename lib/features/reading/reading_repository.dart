import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import 'reading_logic.dart';

class TimerAlreadyRunningException implements Exception {
  const TimerAlreadyRunningException();
  @override
  String toString() => 'A reading timer is already running';
}

class ReadingRepository {
  ReadingRepository(this._db);
  final AppDatabase _db;

  Stream<List<Book>> watchBooks() => (_db.select(
    _db.books,
  )..orderBy([(b) => OrderingTerm.asc(b.title)])).watch();

  Stream<List<ReadingSession>> watchSessions() => (_db.select(
    _db.readingSessions,
  )..orderBy([(s) => OrderingTerm.desc(s.startAt)])).watch();

  Stream<List<ReadingNote>> watchNotes() => (_db.select(
    _db.readingNotes,
  )..orderBy([(n) => OrderingTerm.desc(n.createdAt)])).watch();

  Future<int> addBook(BooksCompanion b) => _db.into(_db.books).insert(b);

  Future<void> updateBook(Book b) => _db.update(_db.books).replace(b);

  /// Marks a book finished (or changes status), keeping finishedAt in step.
  Future<void> setStatus(Book b, BookStatus status, {int? rating}) => _db
      .update(_db.books)
      .replace(
        b.copyWith(
          status: status.name,
          rating: Value(
            status == BookStatus.finished ? rating ?? b.rating : b.rating,
          ),
          finishedAt: Value(
            status == BookStatus.finished ? DateTime.now() : null,
          ),
        ),
      );

  /// Deletes a book with its sessions and notes; returns its cover path so the
  /// caller can remove the file.
  Future<String?> deleteBook(Book b) => _db.transaction(() async {
    await (_db.delete(
      _db.readingNotes,
    )..where((n) => n.bookId.equals(b.id))).go();
    await (_db.delete(
      _db.readingSessions,
    )..where((s) => s.bookId.equals(b.id))).go();
    await (_db.delete(_db.books)..where((x) => x.id.equals(b.id))).go();
    return b.coverPath;
  });

  Future<ReadingSession?> runningSession() => (_db.select(
    _db.readingSessions,
  )..where((s) => s.endAt.isNull())).getSingleOrNull();

  /// Starts the timer for [bookId]. Only one timer may run at a time. A book
  /// that was only "want to read" becomes "reading".
  Future<int> startSession(
    int bookId,
    DateTime now,
  ) => _db.transaction(() async {
    if (await runningSession() != null) {
      throw const TimerAlreadyRunningException();
    }
    await (_db.update(_db.books)..where(
          (b) =>
              b.id.equals(bookId) & b.status.equals(BookStatus.wantToRead.name),
        ))
        .write(BooksCompanion(status: Value(BookStatus.reading.name)));
    return _db
        .into(_db.readingSessions)
        .insert(ReadingSessionsCompanion.insert(bookId: bookId, startAt: now));
  });

  Future<void> stopSession(int id, DateTime now, {int? endPage}) =>
      (_db.update(_db.readingSessions)..where((s) => s.id.equals(id))).write(
        ReadingSessionsCompanion(endAt: Value(now), endPage: Value(endPage)),
      );

  Future<void> deleteSession(int id) => _db.transaction(() async {
    await (_db.update(_db.readingNotes)..where((n) => n.sessionId.equals(id)))
        .write(const ReadingNotesCompanion(sessionId: Value(null)));
    await (_db.delete(_db.readingSessions)..where((s) => s.id.equals(id))).go();
  });

  Future<int> addNote(
    int bookId,
    String text, {
    int? sessionId,
    bool isQuote = false,
    DateTime? at,
  }) => _db
      .into(_db.readingNotes)
      .insert(
        ReadingNotesCompanion.insert(
          bookId: bookId,
          body: text.trim(),
          createdAt: at ?? DateTime.now(),
          sessionId: Value(sessionId),
          isQuote: Value(isQuote),
        ),
      );

  Future<void> deleteNote(int id) =>
      (_db.delete(_db.readingNotes)..where((n) => n.id.equals(id))).go();
}

final readingRepositoryProvider = Provider(
  (ref) => ReadingRepository(ref.watch(databaseProvider)),
);
final booksProvider = StreamProvider(
  (ref) => ref.watch(readingRepositoryProvider).watchBooks(),
);
final readingSessionsProvider = StreamProvider(
  (ref) => ref.watch(readingRepositoryProvider).watchSessions(),
);
final readingNotesProvider = StreamProvider(
  (ref) => ref.watch(readingRepositoryProvider).watchNotes(),
);
