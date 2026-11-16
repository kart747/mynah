import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../core/text/word_tokenizer.dart';
import '../../data/repositories/text_repository.dart';
import 'reader_settings.dart';

/// What the reader is currently emphasising: the sentence being read and
/// (optionally) one word inside a sentence.
class ReaderHighlight {
  const ReaderHighlight({
    this.sentence,
    this.wordSentence,
    this.wordStart = 0,
    this.wordEnd = 0,
    this.pulse = 0,
  });

  static const none = ReaderHighlight();

  /// Global sentence index to shade.
  final int? sentence;

  /// Sentence holding the emphasised word, and its [start, end) offsets.
  final int? wordSentence;
  final int wordStart;
  final int wordEnd;

  /// 0..1 extra opacity on the word, used for the "loading" pulse.
  final double pulse;

  @override
  bool operator ==(Object other) =>
      other is ReaderHighlight &&
      other.sentence == sentence &&
      other.wordSentence == wordSentence &&
      other.wordStart == wordStart &&
      other.wordEnd == wordEnd &&
      other.pulse == pulse;

  @override
  int get hashCode =>
      Object.hash(sentence, wordSentence, wordStart, wordEnd, pulse);
}

/// A word the reader tapped.
class WordHit {
  const WordHit({
    required this.sentenceIdx,
    required this.token,
    required this.sentence,
  });

  final int sentenceIdx;
  final WordToken token;
  final String sentence;

  String get word => token.text;
}

typedef WordTapCallback = void Function(WordHit hit);
typedef SentenceLongPressCallback =
    void Function(int sentenceIdx, Offset globalPosition);

/// One paragraph as a single [RichText]: taps are resolved by text offset,
/// so words are tappable without per-word recognizers and highlighting only
/// changes background colour (never size or weight, so nothing reflows).
class ParagraphView extends StatefulWidget {
  const ParagraphView({
    super.key,
    required this.paragraph,
    required this.settings,
    required this.palette,
    required this.highlight,
    this.onWordTap,
    this.onBlankTap,
    this.onSentenceLongPress,
  });

  final ParagraphText paragraph;
  final ReaderSettings settings;
  final ReaderPalette palette;
  final ValueListenable<ReaderHighlight> highlight;
  final WordTapCallback? onWordTap;
  final VoidCallback? onBlankTap;
  final SentenceLongPressCallback? onSentenceLongPress;

  @override
  State<ParagraphView> createState() => ParagraphViewState();
}

class ParagraphViewState extends State<ParagraphView> {
  final _textKey = GlobalKey();
  late List<int> _starts;

  /// Cache so unrelated highlight changes don't rebuild this paragraph.
  ReaderHighlight? _appliedSlice;
  Widget? _cached;

  @override
  void initState() {
    super.initState();
    _computeStarts();
  }

  @override
  void didUpdateWidget(ParagraphView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paragraph != widget.paragraph) _computeStarts();
    if (oldWidget.settings != widget.settings ||
        oldWidget.palette != widget.palette ||
        oldWidget.paragraph != widget.paragraph) {
      _cached = null;
    }
  }

  void _computeStarts() {
    _starts = [];
    var offset = 0;
    for (final s in widget.paragraph.sentences) {
      _starts.add(offset);
      offset += s.content.length + 1;
    }
    _cached = null;
  }

  bool get _isHeading => widget.paragraph.paragraph.isHeading;

  ReaderHighlight _sliceFor(ReaderHighlight h) {
    final sentences = widget.paragraph.sentences;
    if (sentences.isEmpty) return ReaderHighlight.none;
    final first = sentences.first.idx;
    final last = sentences.last.idx;
    bool inside(int? i) => i != null && i >= first && i <= last;
    return ReaderHighlight(
      sentence: inside(h.sentence) ? h.sentence : null,
      wordSentence: inside(h.wordSentence) ? h.wordSentence : null,
      wordStart: inside(h.wordSentence) ? h.wordStart : 0,
      wordEnd: inside(h.wordSentence) ? h.wordEnd : 0,
      pulse: inside(h.wordSentence) ? h.pulse : 0,
    );
  }

  TextStyle get _baseStyle {
    final s = widget.settings;
    return TextStyle(
      color: widget.palette.text,
      fontFamily: s.fontFamily,
      fontSize: _isHeading ? s.fontSize * 1.28 : s.fontSize,
      height: s.lineHeight,
      fontWeight: _isHeading ? FontWeight.w700 : FontWeight.w400,
    );
  }

  TextSpan _buildSpan(ReaderHighlight slice) {
    final palette = widget.palette;
    final children = <InlineSpan>[];
    final sentences = widget.paragraph.sentences;
    for (var i = 0; i < sentences.length; i++) {
      final s = sentences[i];
      if (i > 0) children.add(const TextSpan(text: ' '));
      final shaded = slice.sentence == s.idx;
      final sentenceStyle = shaded
          ? TextStyle(backgroundColor: palette.sentenceHighlight)
          : null;
      if (slice.wordSentence == s.idx &&
          slice.wordEnd > slice.wordStart &&
          slice.wordEnd <= s.content.length) {
        final wordColor = palette.accent.withValues(
          alpha: (0.42 + 0.3 * slice.pulse).clamp(0.0, 0.8),
        );
        children.add(
          TextSpan(
            style: sentenceStyle,
            children: [
              TextSpan(text: s.content.substring(0, slice.wordStart)),
              TextSpan(
                text: s.content.substring(slice.wordStart, slice.wordEnd),
                style: TextStyle(backgroundColor: wordColor),
              ),
              TextSpan(text: s.content.substring(slice.wordEnd)),
            ],
          ),
        );
      } else {
        children.add(TextSpan(text: s.content, style: sentenceStyle));
      }
    }
    return TextSpan(style: _baseStyle, children: children);
  }

  RenderParagraph? get _render =>
      _textKey.currentContext?.findRenderObject() as RenderParagraph?;

  /// Global rect covering sentence [idx], or null if it isn't laid out.
  Rect? sentenceRect(int idx) {
    final render = _render;
    if (render == null || !render.attached || !render.hasSize) return null;
    final i = widget.paragraph.sentences.indexWhere((s) => s.idx == idx);
    if (i < 0) return null;
    final start = _starts[i];
    final end = start + widget.paragraph.sentences[i].content.length;
    final boxes = render.getBoxesForSelection(
      TextSelection(baseOffset: start, extentOffset: end),
    );
    if (boxes.isEmpty) return null;
    var rect = boxes.first.toRect();
    for (final b in boxes) {
      rect = rect.expandToInclude(b.toRect());
    }
    return rect.shift(render.localToGlobal(Offset.zero));
  }

  /// First sentence of this paragraph whose bottom edge is below [globalY].
  int? firstSentenceBelow(double globalY) {
    for (final s in widget.paragraph.sentences) {
      final r = sentenceRect(s.idx);
      if (r != null && r.bottom > globalY) return s.idx;
    }
    return null;
  }

  /// Sentence index (into this paragraph) holding the paragraph offset.
  int _sentenceAt(int offset) {
    var i = 0;
    for (var k = 0; k < _starts.length; k++) {
      if (_starts[k] <= offset) i = k;
    }
    return i;
  }

  void _onTapUp(TapUpDetails d) {
    final render = _render;
    if (render == null) return widget.onBlankTap?.call();
    final pos = render.getPositionForOffset(d.localPosition).offset;
    final si = _sentenceAt(pos);
    final sentence = widget.paragraph.sentences[si];
    final local = pos - _starts[si];
    for (final t in tokenizeWords(sentence.content)) {
      if (local >= t.start && local <= t.end) {
        final base = _starts[si];
        final boxes = render.getBoxesForSelection(
          TextSelection(baseOffset: base + t.start, extentOffset: base + t.end),
        );
        final hit = boxes.any(
          (b) => b.toRect().inflate(5).contains(d.localPosition),
        );
        if (hit) {
          widget.onWordTap?.call(
            WordHit(
              sentenceIdx: sentence.idx,
              token: t,
              sentence: sentence.content,
            ),
          );
          return;
        }
      }
    }
    widget.onBlankTap?.call();
  }

  void _onLongPress(LongPressStartDetails d) {
    final render = _render;
    if (render == null) return;
    final pos = render.getPositionForOffset(d.localPosition).offset;
    final sentence = widget.paragraph.sentences[_sentenceAt(pos)];
    widget.onSentenceLongPress?.call(sentence.idx, d.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    return ValueListenableBuilder<ReaderHighlight>(
      valueListenable: widget.highlight,
      builder: (context, highlight, _) {
        final slice = _sliceFor(highlight);
        if (_cached != null && slice == _appliedSlice) return _cached!;
        _appliedSlice = slice;
        return _cached = Padding(
          padding: EdgeInsets.only(
            bottom: s.fontSize * (_isHeading ? 0.9 : 0.75),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: _onTapUp,
            onLongPressStart: _onLongPress,
            child: RichText(
              key: _textKey,
              text: _buildSpan(slice),
              textAlign: s.justified && !_isHeading
                  ? TextAlign.justify
                  : TextAlign.start,
              textScaler: MediaQuery.textScalerOf(context),
            ),
          ),
        );
      },
    );
  }
}
