import 'dart:typed_data';

import 'package:epubx/epubx.dart';

import '../../core/text/sentence_splitter.dart';
import '../../core/text/word_tokenizer.dart';
import 'html_text.dart';

class ParsedParagraph {
  const ParsedParagraph(this.sentences, {this.isHeading = false});

  final List<String> sentences;
  final bool isHeading;
}

class ParsedChapter {
  const ParsedChapter(this.title, this.paragraphs);

  final String title;
  final List<ParsedParagraph> paragraphs;

  int get sentenceCount => paragraphs.fold(0, (n, p) => n + p.sentences.length);
}

/// A book reduced to chapters -> paragraphs -> sentences, ready to store.
class ParsedBook {
  const ParsedBook(this.chapters);

  final List<ParsedChapter> chapters;

  int get sentenceCount => chapters.fold(0, (n, c) => n + c.sentenceCount);

  int get wordCount => chapters.fold(
    0,
    (n, c) =>
        n +
        c.paragraphs.fold(
          0,
          (m, p) =>
              m + p.sentences.fold(0, (k, s) => k + tokenizeWords(s).length),
        ),
  );
}

/// Extracts the readable text of an EPUB in spine order.
///
/// Pure Dart (no Flutter imports) so it can run in an isolate.
/// Throws [FormatException] if [bytes] is not a readable EPUB.
Future<ParsedBook> parseEpubText(Uint8List bytes) async {
  final EpubBookRef book;
  try {
    book = await EpubReader.openBook(bytes);
  } catch (e) {
    throw FormatException('Not a readable EPUB: $e');
  }

  final spine = book.Schema?.Package?.Spine?.Items ?? const [];
  final manifest = book.Schema?.Package?.Manifest?.Items ?? const [];
  final html = book.Content?.Html ?? const {};
  final tocTitles = await _tocTitles(book);

  final chapters = <ParsedChapter>[];
  for (final ref in spine) {
    final href = manifest.where((i) => i.Id == ref.IdRef).firstOrNull?.Href;
    final file = href == null ? null : html[href];
    if (href == null || file == null) continue;

    final String content;
    try {
      content = await file.ReadContentAsync();
    } catch (_) {
      continue; // one broken document must not sink the import
    }

    final paragraphs = <ParsedParagraph>[];
    for (final p in htmlToParagraphs(content)) {
      final sentences = p.isHeading ? [p.text] : splitSentences(p.text);
      if (sentences.isEmpty) continue;
      paragraphs.add(ParsedParagraph(sentences, isHeading: p.isHeading));
    }
    if (paragraphs.isEmpty) continue;

    final headingTitle = paragraphs
        .where((p) => p.isHeading)
        .firstOrNull
        ?.sentences
        .first;
    final title =
        tocTitles[_fileKey(href)] ??
        headingTitle ??
        'Section ${chapters.length + 1}';
    chapters.add(ParsedChapter(title.trim(), paragraphs));
  }

  if (chapters.isEmpty) {
    throw const FormatException('This EPUB has no readable text.');
  }
  return ParsedBook(chapters);
}

String _fileKey(String href) =>
    Uri.decodeFull(href.split('#').first).split('/').last.toLowerCase();

Future<Map<String, String>> _tocTitles(EpubBookRef book) async {
  final titles = <String, String>{};
  void walk(List<EpubChapterRef> chapters) {
    for (final c in chapters) {
      final file = c.ContentFileName;
      final title = c.Title?.trim();
      if (file != null && title != null && title.isNotEmpty) {
        titles.putIfAbsent(_fileKey(file), () => title);
      }
      walk(c.SubChapters ?? const []);
    }
  }

  try {
    walk(await book.getChapters());
  } catch (_) {
    // No usable table of contents; fall back to headings.
  }
  return titles;
}
