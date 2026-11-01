import 'dart:typed_data';

import 'package:epubx/epubx.dart';
import 'package:path/path.dart' as p;

/// What the library needs to show a freshly imported EPUB.
class EpubMetadata {
  const EpubMetadata({
    required this.title,
    required this.author,
    required this.wordCount,
    this.coverBytes,
    this.coverExtension,
  });

  final String title;
  final String? author;

  /// Rough count from tag-stripped spine documents; the text pipeline
  /// replaces it with the exact count.
  final int wordCount;
  final Uint8List? coverBytes;

  /// Lower-case extension without the dot, e.g. `jpg`.
  final String? coverExtension;
}

/// Reads title, author, cover and an approximate word count.
///
/// Pure Dart with no Flutter imports, so it is safe to run in an isolate.
/// Throws [FormatException] if [bytes] is not a readable EPUB.
Future<EpubMetadata> readEpubMetadata(
  Uint8List bytes, {
  required String fallbackTitle,
}) async {
  final EpubBookRef book;
  try {
    book = await EpubReader.openBook(bytes);
  } catch (e) {
    throw FormatException('Not a readable EPUB: $e');
  }

  final title = book.Title?.trim();
  final author = book.Author?.trim();
  final cover = await _readCover(book);

  return EpubMetadata(
    title: (title == null || title.isEmpty) ? fallbackTitle : title,
    author: (author == null || author.isEmpty) ? null : author,
    wordCount: await _countWords(book),
    coverBytes: cover?.$1,
    coverExtension: cover?.$2,
  );
}

Future<(Uint8List, String)?> _readCover(EpubBookRef book) async {
  final manifest = book.Schema?.Package?.Manifest?.Items ?? const [];
  final images = book.Content?.Images ?? const {};
  bool isImage(EpubManifestItem i) =>
      i.MediaType?.startsWith('image/') ?? false;

  // EPUB 3 property, then the EPUB 2 <meta name="cover">, then naming.
  var item = manifest
      .where((i) =>
          isImage(i) && (i.Properties?.contains('cover-image') ?? false))
      .firstOrNull;
  if (item == null) {
    final coverId = book.Schema?.Package?.Metadata?.MetaItems
        ?.where((m) => m.Name?.toLowerCase() == 'cover')
        .firstOrNull
        ?.Content;
    if (coverId != null) {
      item = manifest.where((i) => isImage(i) && i.Id == coverId).firstOrNull;
    }
  }
  item ??= manifest
      .where((i) =>
          isImage(i) &&
          ((i.Id?.toLowerCase().contains('cover') ?? false) ||
              (i.Href?.toLowerCase().contains('cover') ?? false)))
      .firstOrNull;

  final href = item?.Href;
  final file = href == null ? null : images[href];
  if (file == null) return null;
  try {
    final data = Uint8List.fromList(await file.readContent());
    var ext = p.extension(href!).replaceFirst('.', '').toLowerCase();
    if (ext.isEmpty) ext = item!.MediaType!.split('/').last;
    return (data, ext);
  } catch (_) {
    return null;
  }
}

final _head = RegExp(r'<head[\s\S]*?</head>', caseSensitive: false);
final _tags = RegExp(r'<[^>]+>');
final _entities = RegExp(r'&[#\w]+;');
final _words = RegExp(r"[\p{L}\p{N}][\p{L}\p{N}'’-]*", unicode: true);

Future<int> _countWords(EpubBookRef book) async {
  final spine = book.Schema?.Package?.Spine?.Items ?? const [];
  final manifest = book.Schema?.Package?.Manifest?.Items ?? const [];
  final html = book.Content?.Html ?? const {};
  var count = 0;
  for (final ref in spine) {
    final href = manifest.where((i) => i.Id == ref.IdRef).firstOrNull?.Href;
    final file = href == null ? null : html[href];
    if (file == null) continue;
    try {
      final text = (await file.ReadContentAsync())
          .replaceAll(_head, ' ')
          .replaceAll(_tags, ' ')
          .replaceAll(_entities, ' ');
      count += _words.allMatches(text).length;
    } catch (_) {
      // A broken chapter shouldn't block the import.
    }
  }
  return count;
}
