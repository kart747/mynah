import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynah/data/book_progress.dart';
import 'package:mynah/data/db/app_database.dart';
import 'package:mynah/data/repositories/book_repository.dart';

BooksCompanion _book(
  String title, {
  String? author,
  int fileSize = 100,
  int sentences = 0,
  int current = 0,
  DateTime? added,
}) => BooksCompanion.insert(
  title: title,
  author: Value(author),
  format: BookFormat.epub,
  filePath: '/books/$title.epub',
  fileSize: fileSize,
  sentenceCount: Value(sentences),
  currentSentence: Value(current),
  addedAt: Value(added ?? DateTime(2026, 1, 1)),
);

void main() {
  late AppDatabase db;
  late BookRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = BookRepository(db);
  });

  tearDown(() => db.close());

  Future<List<String>> titles(LibrarySort sort) async =>
      (await repo.watchBooks(sort).first).map((b) => b.title).toList();

  test('sorts by title case-insensitively', () async {
    await repo.addBook(_book('beta'));
    await repo.addBook(_book('Alpha'));
    await repo.addBook(_book('Gamma'));
    expect(await titles(LibrarySort.title), ['Alpha', 'beta', 'Gamma']);
  });

  test('sorts by last opened, never-opened last by newest added', () async {
    final a = await repo.addBook(_book('A', added: DateTime(2026, 1, 1)));
    await repo.addBook(_book('B', added: DateTime(2026, 1, 3)));
    await repo.addBook(_book('C', added: DateTime(2026, 1, 2)));
    final d = await repo.addBook(_book('D'));
    await repo.markOpened(a, at: DateTime(2026, 2, 1));
    await repo.markOpened(d, at: DateTime(2026, 2, 2));
    expect(await titles(LibrarySort.lastOpened), ['D', 'A', 'B', 'C']);
  });

  test('sorts by progress, unprocessed books last', () async {
    await repo.addBook(_book('Half', sentences: 100, current: 50));
    await repo.addBook(_book('New'));
    await repo.addBook(_book('Most', sentences: 10, current: 9));
    await repo.addBook(_book('Started', sentences: 10, current: 1));
    expect(await titles(LibrarySort.progress), [
      'Most',
      'Half',
      'Started',
      'New',
    ]);
  });

  test('deleteBook removes the row', () async {
    final id = await repo.addBook(_book('Gone'));
    await repo.deleteBook(id);
    expect(await repo.getBook(id), isNull);
  });

  test('findDuplicate matches title, author and size', () async {
    await repo.addBook(_book('Emma', author: 'Austen', fileSize: 42));
    expect(
      await repo.findDuplicate(title: 'Emma', author: 'Austen', fileSize: 42),
      isNotNull,
    );
    expect(
      await repo.findDuplicate(title: 'Emma', author: 'Austen', fileSize: 43),
      isNull,
    );
    expect(
      await repo.findDuplicate(title: 'Emma', author: null, fileSize: 42),
      isNull,
    );
  });

  test('progress and time left', () async {
    final id = await repo.addBook(
      _book(
        'P',
        sentences: 200,
        current: 50,
      ).copyWith(wordCount: const Value(2300)),
    );
    final book = (await repo.getBook(id))!;
    expect(book.progress, 0.25);
    expect(book.minutesLeft(), 8); // 1725 words / 230 wpm = 7.5 -> 8
    expect(formatTimeLeft(0), '<1m left');
    expect(formatTimeLeft(45), '45m left');
    expect(formatTimeLeft(120), '2h left');
    expect(formatTimeLeft(200), '3h 20m left');
  });
}
