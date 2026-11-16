/// A block of readable text pulled out of an (X)HTML document.
class HtmlParagraph {
  const HtmlParagraph(this.text, {this.isHeading = false});

  final String text;
  final bool isHeading;

  @override
  String toString() => isHeading ? '# $text' : text;
}

const _blockTags = {
  'p',
  'div',
  'section',
  'article',
  'header',
  'footer',
  'aside',
  'main',
  'blockquote',
  'li',
  'ul',
  'ol',
  'dl',
  'dt',
  'dd',
  'tr',
  'td',
  'th',
  'table',
  'pre',
  'figure',
  'figcaption',
  'hr',
  'body',
  'nav',
  'address',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
};

const _headingTags = {'h1', 'h2', 'h3', 'h4', 'h5', 'h6'};

/// Content of these is never read aloud.
const _skipTags = {'head', 'script', 'style', 'title', 'svg', 'math', 'rt'};

const _voidTags = {
  'br',
  'img',
  'hr',
  'meta',
  'link',
  'input',
  'col',
  'area',
  'base',
  'wbr',
  'source',
  'embed',
  'param',
  'track',
};

final _tag = RegExp(
  r'<(/?)([a-zA-Z][\w:-]*)([^>]*?)(/?)>|<!--[\s\S]*?-->|<\?[\s\S]*?\?>|<!\[CDATA\[([\s\S]*?)\]\]>|<![^>]*>',
);
final _pageMarker = RegExp(
  r'''(class\s*=\s*["'][^"']*\bpagenum\b|epub:type\s*=\s*["'][^"']*\bpagebreak\b|role\s*=\s*["']doc-pagebreak)''',
  caseSensitive: false,
);
final _space = RegExp(r'\s+');

/// Converts an (X)HTML chapter into paragraphs of plain text.
///
/// Tolerant of sloppy markup: tags are scanned, not parsed into a tree.
/// Block elements and `<br>` break paragraphs' text runs; inline elements
/// are flattened. Page-number markers are dropped.
List<HtmlParagraph> htmlToParagraphs(String html) {
  final out = <HtmlParagraph>[];
  final buffer = StringBuffer();
  var headingDepth = 0;
  var bufferIsHeading = false;

  // Open elements whose content we are skipping, innermost last.
  final skipping = <String>[];
  // Inline elements opened inside a skipped page marker, to find its end.
  var markerDepth = 0;

  void flush() {
    final text = decodeEntities(
      buffer.toString(),
    ).replaceAll(_space, ' ').trim();
    if (text.isNotEmpty) {
      out.add(HtmlParagraph(text, isHeading: bufferIsHeading));
    }
    buffer.clear();
    bufferIsHeading = headingDepth > 0;
  }

  void addText(String text) {
    if (skipping.isNotEmpty) return;
    if (buffer.isEmpty || buffer.toString().trim().isEmpty) {
      bufferIsHeading = headingDepth > 0;
    }
    buffer.write(text);
  }

  var pos = 0;
  for (final m in _tag.allMatches(html)) {
    addText(html.substring(pos, m.start));
    pos = m.end;

    if (m.group(5) != null) {
      addText(m.group(5)!);
      continue;
    }
    final rawName = m.group(2);
    if (rawName == null) continue; // comment, doctype, processing instruction
    final name = rawName.toLowerCase().split(':').last;
    final closing = m.group(1) == '/';
    final selfClosing = m.group(4) == '/' || _voidTags.contains(name);
    final attrs = m.group(3) ?? '';

    if (skipping.isNotEmpty) {
      if (closing) {
        if (skipping.last == name) {
          if (markerDepth > 0) {
            markerDepth--;
            if (markerDepth > 0) continue;
          }
          skipping.removeLast();
        }
      } else if (!selfClosing && name == skipping.last && markerDepth > 0) {
        markerDepth++;
      }
      continue;
    }

    if (!closing &&
        !selfClosing &&
        (_skipTags.contains(name) || _pageMarker.hasMatch(attrs))) {
      skipping.add(name);
      if (!_skipTags.contains(name)) markerDepth = 1;
      continue;
    }

    if (name == 'br') {
      // Line breaks inside headings ("CHAPTER I.<br/>Down the Rabbit-Hole")
      // and verse read better as one flowing paragraph.
      buffer.write(' ');
      continue;
    }
    if (name == 'img' && !closing) {
      final alt = RegExp(r'''alt\s*=\s*["']([^"']*)["']''').firstMatch(attrs);
      // Drop-cap images carry the first letter of the paragraph in alt.
      if (alt != null && alt.group(1)!.trim().length == 1) {
        addText(alt.group(1)!);
      }
      continue;
    }

    if (_blockTags.contains(name)) {
      flush();
      if (_headingTags.contains(name)) {
        headingDepth += closing ? -1 : (selfClosing ? 0 : 1);
        if (headingDepth < 0) headingDepth = 0;
        bufferIsHeading = headingDepth > 0;
      }
    }
  }
  addText(html.substring(pos));
  flush();
  return out;
}

const _named = {
  'amp': '&',
  'lt': '<',
  'gt': '>',
  'quot': '"',
  'apos': "'",
  'nbsp': ' ',
  'ensp': ' ',
  'emsp': ' ',
  'thinsp': ' ',
  'shy': '',
  'zwnj': '',
  'zwj': '',
  'mdash': '—',
  'ndash': '–',
  'hellip': '…',
  'lsquo': '‘',
  'rsquo': '’',
  'ldquo': '“',
  'rdquo': '”',
  'sbquo': '‚',
  'bdquo': '„',
  'laquo': '«',
  'raquo': '»',
  'lsaquo': '‹',
  'rsaquo': '›',
  'copy': '©',
  'reg': '®',
  'trade': '™',
  'deg': '°',
  'middot': '·',
  'bull': '•',
  'dagger': '†',
  'Dagger': '‡',
  'sect': '§',
  'para': '¶',
  'pound': '£',
  'euro': '€',
  'cent': '¢',
  'yen': '¥',
  'times': '×',
  'divide': '÷',
  'frac12': '½',
  'frac14': '¼',
  'frac34': '¾',
  'prime': '′',
  'Prime': '″',
  'iexcl': '¡',
  'iquest': '¿',
  'aelig': 'æ',
  'AElig': 'Æ',
  'oelig': 'œ',
  'OElig': 'Œ',
  'szlig': 'ß',
  'eacute': 'é',
  'Eacute': 'É',
  'egrave': 'è',
  'Egrave': 'È',
  'ecirc': 'ê',
  'euml': 'ë',
  'aacute': 'á',
  'agrave': 'à',
  'acirc': 'â',
  'auml': 'ä',
  'Auml': 'Ä',
  'aring': 'å',
  'atilde': 'ã',
  'ccedil': 'ç',
  'Ccedil': 'Ç',
  'iacute': 'í',
  'igrave': 'ì',
  'icirc': 'î',
  'iuml': 'ï',
  'ntilde': 'ñ',
  'oacute': 'ó',
  'ograve': 'ò',
  'ocirc': 'ô',
  'ouml': 'ö',
  'Ouml': 'Ö',
  'otilde': 'õ',
  'oslash': 'ø',
  'uacute': 'ú',
  'ugrave': 'ù',
  'ucirc': 'û',
  'uuml': 'ü',
  'Uuml': 'Ü',
  'yacute': 'ý',
  'yuml': 'ÿ',
};

final _entity = RegExp(r'&(#[xX][0-9a-fA-F]+|#\d+|[a-zA-Z][a-zA-Z0-9]*);');

String decodeEntities(String text) => text.replaceAllMapped(_entity, (m) {
  final body = m.group(1)!;
  if (body.startsWith('#')) {
    final hex = body.length > 1 && (body[1] == 'x' || body[1] == 'X');
    final code = int.tryParse(
      hex ? body.substring(2) : body.substring(1),
      radix: hex ? 16 : 10,
    );
    if (code == null || code <= 0 || code > 0x10FFFF) return m.group(0)!;
    if (code == 0xA0 || code == 0x2002 || code == 0x2003 || code == 0x2009) {
      return ' ';
    }
    if (code == 0xAD) return '';
    return String.fromCharCode(code);
  }
  return _named[body] ?? m.group(0)!;
});
