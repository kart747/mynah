/// A word inside a sentence, with character offsets into that sentence.
class WordToken {
  const WordToken(this.text, this.start, this.end);

  final String text;

  /// UTF-16 offsets into the sentence: [start, end).
  final int start;
  final int end;

  @override
  String toString() => '$text[$start,$end)';

  @override
  bool operator ==(Object other) =>
      other is WordToken &&
      other.text == text &&
      other.start == start &&
      other.end == end;

  @override
  int get hashCode => Object.hash(text, start, end);
}

// Letters/digits, with inner apostrophes and hyphens kept ("don’t", "well-known").
final _word = RegExp(r"[\p{L}\p{N}]+(?:['’‑\-][\p{L}\p{N}]+)*", unicode: true);

List<WordToken> tokenizeWords(String sentence) => [
  for (final m in _word.allMatches(sentence))
    WordToken(m.group(0)!, m.start, m.end),
];

/// Normalises a tapped word for dictionary lookup: lower case, curly
/// apostrophes straightened, leading/trailing punctuation removed.
String normalizeWord(String word) => word
    .toLowerCase()
    .replaceAll('’', "'")
    .replaceAll(RegExp(r"^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$", unicode: true), '');
