import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../data/db/app_database.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/text_repository.dart';
import 'epub_metadata.dart';
import 'epub_text.dart';

sealed class ImportResult {
  const ImportResult(this.fileName);
  final String fileName;
}

class ImportSuccess extends ImportResult {
  const ImportSuccess(super.fileName, this.bookId, this.title);
  final int bookId;
  final String title;
}

class ImportDuplicate extends ImportResult {
  const ImportDuplicate(super.fileName, this.existing);
  final Book existing;
}

class ImportFailure extends ImportResult {
  const ImportFailure(super.fileName, this.reason);
  final String reason;
}

/// Copies picked files into app storage and registers them in the library.
class ImportService {
  ImportService(this._repo, this._text, this._rootDir);

  final BookRepository _repo;
  final TextRepository _text;

  /// App documents dir; books and covers live in subfolders of it.
  final Future<Directory> Function() _rootDir;

  Future<ImportResult> importEpub(String fileName, Uint8List bytes) async {
    final fallbackTitle = p.basenameWithoutExtension(fileName);
    final EpubMetadata meta;
    final ParsedBook parsed;
    try {
      // Parsing is the heavy part: keep it off the UI isolate.
      (meta, parsed) = await Isolate.run(
        () async => (
          await readEpubMetadata(bytes, fallbackTitle: fallbackTitle),
          await parseEpubText(bytes),
        ),
      );
    } on FormatException catch (e) {
      return ImportFailure(
        fileName,
        e.message.contains('no readable text')
            ? 'no readable text in this EPUB'
            : 'not a valid EPUB file',
      );
    }

    final existing = await _repo.findDuplicate(
      title: meta.title,
      author: meta.author,
      fileSize: bytes.length,
    );
    if (existing != null) return ImportDuplicate(fileName, existing);

    final root = await _rootDir();
    final stem = DateTime.now().microsecondsSinceEpoch.toString();
    final bookFile = File(p.join(root.path, 'books', '$stem.epub'));
    await bookFile.parent.create(recursive: true);
    await bookFile.writeAsBytes(bytes, flush: true);

    File? coverFile;
    if (meta.coverBytes != null) {
      coverFile = File(
        p.join(root.path, 'covers', '$stem.${meta.coverExtension}'),
      );
      await coverFile.parent.create(recursive: true);
      await coverFile.writeAsBytes(meta.coverBytes!, flush: true);
    }

    final id = await _repo.addBook(
      BooksCompanion.insert(
        title: meta.title,
        author: Value(meta.author),
        format: BookFormat.epub,
        filePath: bookFile.path,
        coverPath: Value(coverFile?.path),
        fileSize: bytes.length,
        wordCount: Value(meta.wordCount),
      ),
    );
    await _text.storeParsed(id, parsed);
    return ImportSuccess(fileName, id, meta.title);
  }

  /// Builds the sentence index for a book imported before the text pipeline
  /// existed (or whose index was cleared). No-op when already indexed.
  Future<void> ensureIndexed(Book book) async {
    if (book.sentenceCount > 0 && book.status == ImportStatus.ready) return;
    final bytes = await File(book.filePath).readAsBytes();
    final parsed = await Isolate.run(() => parseEpubText(bytes));
    await _text.storeParsed(book.id, parsed);
  }

  /// Removes the book row and its stored files.
  Future<void> deleteBook(Book book) async {
    await _repo.deleteBook(book.id);
    for (final path in [book.filePath, book.coverPath]) {
      if (path == null) continue;
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
  }
}
