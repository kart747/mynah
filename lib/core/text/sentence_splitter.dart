/// Splits a paragraph into sentences.
///
/// Rule-based and offline. Handles common abbreviations (Mr., Dr., e.g.),
/// initials (J. R. R. Tolkien), decimals, ellipses and closing quotes
/// ("Stop." He ran. -> two sentences). Sentences never cross paragraphs.
library;

const _abbreviations = {
  'mr', 'mrs', 'ms', 'mx', 'dr', 'prof', 'sr', 'jr', 'st', 'mt', 'vs', //
  'gen', 'col', 'lt', 'capt', 'sgt', 'cpl', 'maj', 'cmdr', 'adm', 'rev',
  'hon', 'fig', 'inc', 'ltd', 'co', 'corp', 'dept', 'approx', 'est', 'vol',
  'ch', 'pp', 'cf', 'viz', 'ca', 'esq', 'messrs', 'mme', 'mlle',
  'jan', 'feb', 'mar', 'apr', 'jun', 'jul', 'aug', 'sep', 'sept', 'oct',
  'nov', 'dec',
};

bool _isUpper(String c) => c != c.toLowerCase() && c == c.toUpperCase();
bool _isLetter(String c) => c.toLowerCase() != c.toUpperCase();
bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
bool _isSpace(String c) => c.trim().isEmpty;

const _terminators = {'.', '!', '?', '…'};
const _closers = {'"', "'", '”', '’', ')', ']', '»', '›'};
const _openers = {'"', "'", '“', '‘', '(', '[', '«', '‹', '—', '-'};

List<String> splitSentences(String paragraph) {
  final text = paragraph.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (text.isEmpty) return const [];

  final out = <String>[];
  var start = 0;
  var i = 0;
  while (i < text.length) {
    final c = text[i];
    if (!_terminators.contains(c)) {
      i++;
      continue;
    }
    // Consume the whole run of terminators ("?!", "...", "…").
    var end = i + 1;
    while (end < text.length && _terminators.contains(text[end])) {
      end++;
    }
    final run = text.substring(i, end);
    // Then any closing quotes/brackets that belong to this sentence.
    var after = end;
    while (after < text.length && _closers.contains(text[after])) {
      after++;
    }
    if (after >= text.length) break; // the rest is the final sentence

    if (_isBoundary(text, start, i, run, after)) {
      out.add(text.substring(start, after).trim());
      while (after < text.length && _isSpace(text[after])) {
        after++;
      }
      start = after;
    }
    i = after;
  }
  if (start < text.length) {
    final tail = text.substring(start).trim();
    if (tail.isNotEmpty) out.add(tail);
  }
  return out;
}

bool _isBoundary(
  String text,
  int sentenceStart,
  int termStart,
  String run,
  int after,
) {
  // Must be followed by whitespace, then something that can start a sentence.
  if (!_isSpace(text[after])) return false;
  var next = after;
  while (next < text.length && _isSpace(text[next])) {
    next++;
  }
  if (next >= text.length) return true;
  var first = text[next];
  var look = next;
  while (_openers.contains(first) && look + 1 < text.length) {
    look++;
    first = text[look];
  }
  final startsSentence = _isUpper(first) || _isDigit(first);
  final lowerNext = _isLetter(first) && !_isUpper(first);

  final isEllipsis =
      run.length > 1 && run.codeUnits.every((u) => u == 46) || run == '…';
  if (isEllipsis) {
    // "Well... I suppose": a lone interjection before the ellipsis is not a
    // sentence of its own.
    final before = text.substring(sentenceStart, termStart).trim();
    if (!before.contains(' ')) return false;
    return startsSentence;
  }

  if (run == '.') {
    if (lowerNext) return false;
    if (_endsWithAbbreviation(text, termStart)) return false;
    return startsSentence || _openers.contains(text[next]);
  }
  // ! or ? (or mixes): a lowercase continuation ("Why?" she asked) is not a break.
  return !lowerNext;
}

bool _endsWithAbbreviation(String text, int dotIndex) {
  var s = dotIndex;
  while (s > 0 && _isLetter(text[s - 1])) {
    s--;
  }
  final word = text.substring(s, dotIndex);
  if (word.isEmpty) {
    // "3.5", "p.m." fragments: digit before the dot with a digit after.
    return dotIndex > 0 &&
        _isDigit(text[dotIndex - 1]) &&
        dotIndex + 1 < text.length &&
        _isDigit(text[dotIndex + 1]);
  }
  final lower = word.toLowerCase();
  if (_abbreviations.contains(lower)) return true;
  // Single capital letter: an initial ("J. Smith").
  if (word.length == 1 && _isUpper(word)) return true;
  // Dotted abbreviations: e.g. / i.e. / a.m. / U.S.A.
  if (s >= 2 && text[s - 1] == '.' && _isLetter(text[s - 2])) return true;
  if (word.length == 1 &&
      dotIndex + 2 < text.length &&
      _isLetter(text[dotIndex + 1]) &&
      text[dotIndex + 2] == '.') {
    return true;
  }
  return false;
}
