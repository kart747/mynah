import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynah/data/db/app_database.dart';
import 'package:mynah/data/repositories/book_repository.dart';
import 'package:mynah/data/repositories/text_repository.dart';
import 'package:mynah/features/import/import_service.dart';

void main() {
  late AppDatabase db;
  late BookRepository repo;
  late TextRepository text;
  late Directory root;
  late ImportService service;
  final alice = File(
    'assets/samples/alice-in-wonderland.epub',
  ).readAsBytesSync();

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = BookRepository(db);
    text = TextRepository(db);
    root = await Directory.systemTemp.createTemp('mynah_import_test');
    service = ImportService(repo, text, () async => root);
  });

  tearDown(() async {
    await db.close();
    await root.delete(recursive: true);
  });

  test('imports an EPUB and stores the file and cover', () async {
    final result = await service.importEpub('alice.epub', alice);

    expect(result, isA<ImportSuccess>());
    final book = (await repo.getBook((result as ImportSuccess).bookId))!;
    expect(book.title, "Alice's Adventures in Wonderland");
    expect(book.author, 'Lewis Carroll');
    expect(book.format, BookFormat.epub);
    expect(book.status, ImportStatus.ready);
    expect(book.wordCount, greaterThan(20000));
    expect(book.sentenceCount, greaterThan(1000));
    final chapters = await text.chapters(book.id);
    expect(chapters.length, greaterThan(10));
    expect(chapters.first.firstSentence, 0);
    expect(
      chapters.fold<int>(0, (n, c) => n + c.sentenceCount),
      book.sentenceCount,
    );
    expect(File(book.filePath).readAsBytesSync(), alice);
    expect(File(book.coverPath!).existsSync(), isTrue);
  });

  test('reports a duplicate instead of importing twice', () async {
    await service.importEpub('alice.epub', alice);
    final again = await service.importEpub('alice copy.epub', alice);

    expect(again, isA<ImportDuplicate>());
    expect(await repo.watchBooks(LibrarySort.title).first, hasLength(1));
  });

  test('fails cleanly on a non-EPUB file', () async {
    final result = await service.importEpub(
      'notes.epub',
      Uint8List.fromList([0, 1, 2]),
    );

    expect(result, isA<ImportFailure>());
    expect(await repo.watchBooks(LibrarySort.title).first, isEmpty);
  });

  test('ensureIndexed rebuilds the index for a book without text', () async {
    final id =
        (await service.importEpub('alice.epub', alice) as ImportSuccess).bookId;
    await text.clear(id);
    await (db.update(db.books)..where((b) => b.id.equals(id))).write(
      const BooksCompanion(
        sentenceCount: Value(0),
        status: Value(ImportStatus.pending),
      ),
    );

    await service.ensureIndexed((await repo.getBook(id))!);

    expect((await repo.getBook(id))!.sentenceCount, greaterThan(1000));
    expect((await text.chapters(id)), isNotEmpty);
  });

  test('deleteBook removes the row and stored files', () async {
    final id =
        (await service.importEpub('alice.epub', alice) as ImportSuccess).bookId;
    final book = (await repo.getBook(id))!;

    await service.deleteBook(book);

    expect(await repo.getBook(id), isNull);
    expect(File(book.filePath).existsSync(), isFalse);
    expect(File(book.coverPath!).existsSync(), isFalse);
  });
}
