import 'package:drift/drift.dart';

import '../db/app_database.dart';

enum LibrarySort { lastOpened, title, progress }

class BookRepository {
  BookRepository(this._db);

  final AppDatabase _db;

  Stream<List<Book>> watchBooks(LibrarySort sort) {
    final query = _db.select(_db.books)..orderBy(_ordering(sort));
    return query.watch();
  }

  Future<Book?> getBook(int id) =>
      (_db.select(_db.books)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> addBook(BooksCompanion book) => _db.into(_db.books).insert(book);

  Future<void> markOpened(int id, {DateTime? at}) =>
      (_db.update(_db.books)..where((b) => b.id.equals(id))).write(
        BooksCompanion(lastOpenedAt: Value(at ?? DateTime.now())),
      );

  Future<void> deleteBook(int id) =>
      (_db.delete(_db.books)..where((b) => b.id.equals(id))).go();

  /// Same title, author and byte size is treated as the same book.
  Future<Book?> findDuplicate({
    required String title,
    required String? author,
    required int fileSize,
  }) {
    final query = _db.select(_db.books)
      ..where(
        (b) =>
            b.title.equals(title) &
            b.fileSize.equals(fileSize) &
            (author == null ? b.author.isNull() : b.author.equals(author)),
      )
      ..limit(1);
    return query.getSingleOrNull();
  }

  List<OrderClauseGenerator<$BooksTable>> _ordering(LibrarySort sort) {
    switch (sort) {
      case LibrarySort.lastOpened:
        // SQLite sorts NULL lowest, so never-opened books fall to the end.
        return [
          (b) => OrderingTerm.desc(b.lastOpenedAt),
          (b) => OrderingTerm.desc(b.addedAt),
        ];
      case LibrarySort.title:
        return [(b) => OrderingTerm.asc(b.title.collate(Collate.noCase))];
      case LibrarySort.progress:
        return [
          (b) => OrderingTerm.desc(
            b.currentSentence.cast<double>() / b.sentenceCount.cast<double>(),
          ),
          (b) => OrderingTerm.asc(b.title.collate(Collate.noCase)),
        ];
    }
  }
}
