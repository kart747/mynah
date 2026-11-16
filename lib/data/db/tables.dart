import 'package:drift/drift.dart';

/// Import formats the pipeline understands.
enum BookFormat { epub, pdf }

/// Where a book is in the import pipeline.
enum ImportStatus { pending, ready, failed }

class Books extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get format => textEnum<BookFormat>()();

  /// Absolute path of the copy inside the app documents dir.
  TextColumn get filePath => text()();

  /// Absolute path of the extracted cover image, if the book has one.
  TextColumn get coverPath => text().nullable()();
  IntColumn get fileSize => integer()();

  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  IntColumn get sentenceCount => integer().withDefault(const Constant(0))();

  /// Global sentence index of the reading position (single source of truth).
  IntColumn get currentSentence => integer().withDefault(const Constant(0))();

  TextColumn get status => textEnum<ImportStatus>()
      .withDefault(Constant(ImportStatus.pending.name))();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
}

/// One spine document. Chapters partition the global sentence index.
class Chapters extends Table {
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();
  IntColumn get idx => integer()();
  TextColumn get title => text()();

  /// Global index of the chapter's first sentence.
  IntColumn get firstSentence => integer()();
  IntColumn get sentenceCount => integer()();

  @override
  Set<Column> get primaryKey => {bookId, idx};
}

/// A paragraph (or heading) and the run of sentences it holds.
class Paragraphs extends Table {
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();
  IntColumn get idx => integer()();
  IntColumn get chapterIdx => integer()();
  BoolColumn get isHeading => boolean().withDefault(const Constant(false))();
  IntColumn get firstSentence => integer()();
  IntColumn get sentenceCount => integer()();

  @override
  Set<Column> get primaryKey => {bookId, idx};
}

/// The sentence index: single source of truth for reading position,
/// read-aloud, highlighting and AI context.
class Sentences extends Table {
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();

  /// Global, 0-based, in reading order.
  IntColumn get idx => integer()();
  IntColumn get chapterIdx => integer()();
  IntColumn get paragraphIdx => integer()();
  TextColumn get content => text()();

  @override
  Set<Column> get primaryKey => {bookId, idx};
}
