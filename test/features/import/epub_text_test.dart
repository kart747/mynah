import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mynah/features/import/epub_text.dart';

void main() {
  test('parses a real EPUB into chapters, paragraphs and sentences', () async {
    final bytes = File(
      'assets/samples/alice-in-wonderland.epub',
    ).readAsBytesSync();
    final sw = Stopwatch()..start();
    final book = await parseEpubText(bytes);
    // ignore: avoid_print
    print(
      'parsed in ${sw.elapsedMilliseconds}ms: ${book.chapters.length} '
      'chapters, ${book.sentenceCount} sentences, ${book.wordCount} words',
    );

    expect(book.chapters.length, greaterThan(10));
    expect(book.sentenceCount, greaterThan(1000));
    expect(book.wordCount, inInclusiveRange(20000, 40000));
    final all = book.chapters.expand((c) => c.paragraphs).toList();
    expect(all.every((p) => p.sentences.isNotEmpty), isTrue);
    final text = all.expand((p) => p.sentences).join(' ');
    expect(text, contains('Down the Rabbit-Hole'));
    expect(text, isNot(contains('<')));
    expect(book.chapters.map((c) => c.title), everyElement(isNotEmpty));
  });

  test('rejects garbage', () async {
    expect(
      parseEpubText(File('pubspec.yaml').readAsBytesSync()),
      throwsA(isA<FormatException>()),
    );
  });
}
