import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mynah/features/import/epub_metadata.dart';

void main() {
  Future<EpubMetadata> read(String name) => readEpubMetadata(
        File('assets/samples/$name').readAsBytesSync(),
        fallbackTitle: 'fallback',
      );

  test('reads title, author and cover of Alice', () async {
    final meta = await read('alice-in-wonderland.epub');
    expect(meta.title, "Alice's Adventures in Wonderland");
    expect(meta.author, 'Lewis Carroll');
    expect(meta.coverExtension, 'jpg');
    // JPEG magic bytes.
    expect(meta.coverBytes!.sublist(0, 2), [0xFF, 0xD8]);
    // ~26.5k words of story plus the Gutenberg licence.
    expect(meta.wordCount, inInclusiveRange(25000, 40000));
  });

  test('reads Sherlock Holmes', () async {
    final meta = await read('adventures-of-sherlock-holmes.epub');
    expect(meta.title, 'The Adventures of Sherlock Holmes');
    expect(meta.author, 'Arthur Conan Doyle');
    expect(meta.coverBytes, isNotNull);
    expect(meta.wordCount, greaterThan(100000));
  });

  test('rejects non-EPUB bytes', () {
    expect(
      readEpubMetadata(Uint8List.fromList([1, 2, 3]), fallbackTitle: 'x'),
      throwsFormatException,
    );
  });
}
