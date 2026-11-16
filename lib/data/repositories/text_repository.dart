import 'package:drift/drift.dart';

import '../../features/import/epub_text.dart';
import '../db/app_database.dart';

/// A chapter's paragraphs with their sentences, ready to lay out.
class ChapterText {
  const ChapterText(this.chapter, this.paragraphs);

  final Chapter chapter;
  final List<ParagraphText> paragraphs;
}

class ParagraphText {
  const ParagraphText(this.paragraph, this.sentences);

  final Paragraph paragraph;
  final List<Sentence> sentences;
}

/// Reads and writes the book -> chapter -> paragraph -> sentence index.
class TextRepository {
  TextRepository(this._db);

  final AppDatabase _db;

  /// Replaces any stored text for [bookId] and marks the book ready.
  Future<void> storeParsed(int bookId, ParsedBook parsed) =>
      _db.transaction(() async {
        await clear(bookId);
        var sentenceIdx = 0;
        var paragraphIdx = 0;
        final chapters = <ChaptersCompanion>[];
        final paragraphs = <ParagraphsCompanion>[];
        final sentences = <SentencesCompanion>[];

        for (var c = 0; c < parsed.chapters.length; c++) {
          final chapter = parsed.chapters[c];
          chapters.add(
            ChaptersCompanion.insert(
              bookId: bookId,
              idx: c,
              title: chapter.title,
              firstSentence: sentenceIdx,
              sentenceCount: chapter.sentenceCount,
            ),
          );
          for (final p in chapter.paragraphs) {
            paragraphs.add(
              ParagraphsCompanion.insert(
                bookId: bookId,
                idx: paragraphIdx,
                chapterIdx: c,
                isHeading: Value(p.isHeading),
                firstSentence: sentenceIdx,
                sentenceCount: p.sentences.length,
              ),
            );
            for (final s in p.sentences) {
              sentences.add(
                SentencesCompanion.insert(
                  bookId: bookId,
                  idx: sentenceIdx++,
                  chapterIdx: c,
                  paragraphIdx: paragraphIdx,
                  content: s,
                ),
              );
            }
            paragraphIdx++;
          }
        }

        await _db.batch((b) {
          b.insertAll(_db.chapters, chapters);
          b.insertAll(_db.paragraphs, paragraphs);
          b.insertAll(_db.sentences, sentences);
        });
        await (_db.update(_db.books)..where((x) => x.id.equals(bookId))).write(
          BooksCompanion(
            wordCount: Value(parsed.wordCount),
            sentenceCount: Value(sentenceIdx),
            status: const Value(ImportStatus.ready),
          ),
        );
      });

  Future<void> clear(int bookId) async {
    await (_db.delete(
      _db.sentences,
    )..where((s) => s.bookId.equals(bookId))).go();
    await (_db.delete(
      _db.paragraphs,
    )..where((s) => s.bookId.equals(bookId))).go();
    await (_db.delete(
      _db.chapters,
    )..where((s) => s.bookId.equals(bookId))).go();
  }

  Future<List<Chapter>> chapters(int bookId) =>
      (_db.select(_db.chapters)
            ..where((c) => c.bookId.equals(bookId))
            ..orderBy([(c) => OrderingTerm.asc(c.idx)]))
          .get();

  Future<ChapterText> loadChapter(int bookId, int chapterIdx) async {
    final chapter =
        await (_db.select(
              _db.chapters,
            )..where((c) => c.bookId.equals(bookId) & c.idx.equals(chapterIdx)))
            .getSingle();
    final paragraphs =
        await (_db.select(_db.paragraphs)
              ..where(
                (p) =>
                    p.bookId.equals(bookId) & p.chapterIdx.equals(chapterIdx),
              )
              ..orderBy([(p) => OrderingTerm.asc(p.idx)]))
            .get();
    final sentences =
        await (_db.select(_db.sentences)
              ..where(
                (s) =>
                    s.bookId.equals(bookId) & s.chapterIdx.equals(chapterIdx),
              )
              ..orderBy([(s) => OrderingTerm.asc(s.idx)]))
            .get();

    final byParagraph = <int, List<Sentence>>{};
    for (final s in sentences) {
      (byParagraph[s.paragraphIdx] ??= []).add(s);
    }
    return ChapterText(chapter, [
      for (final p in paragraphs)
        ParagraphText(p, byParagraph[p.idx] ?? const []),
    ]);
  }

  Future<Sentence?> sentenceAt(int bookId, int idx) =>
      (_db.select(_db.sentences)
            ..where((s) => s.bookId.equals(bookId) & s.idx.equals(idx)))
          .getSingleOrNull();

  /// Sentences [from]..[to] inclusive, in order.
  Future<List<Sentence>> sentencesBetween(int bookId, int from, int to) =>
      (_db.select(_db.sentences)
            ..where(
              (s) =>
                  s.bookId.equals(bookId) &
                  s.idx.isBiggerOrEqualValue(from) &
                  s.idx.isSmallerOrEqualValue(to),
            )
            ..orderBy([(s) => OrderingTerm.asc(s.idx)]))
          .get();

  /// Index of the chapter holding global sentence [sentenceIdx].
  Future<int> chapterIndexOf(int bookId, int sentenceIdx) async {
    final row =
        await (_db.select(_db.chapters)
              ..where(
                (c) =>
                    c.bookId.equals(bookId) &
                    c.firstSentence.isSmallerOrEqualValue(sentenceIdx),
              )
              ..orderBy([(c) => OrderingTerm.desc(c.idx)])
              ..limit(1))
            .getSingleOrNull();
    return row?.idx ?? 0;
  }
}
