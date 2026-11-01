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
