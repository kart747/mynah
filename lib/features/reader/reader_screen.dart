import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/text_repository.dart';
import '../import/import_controller.dart';
import 'paragraph_view.dart';
import 'reader_settings.dart';
import 'reader_settings_sheet.dart';
import 'reading_position.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key, required this.bookId});

  final int bookId;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen>
    with WidgetsBindingObserver {
  final _scroll = ScrollController();
  final _viewportKey = GlobalKey();
  final _highlight = ValueNotifier<ReaderHighlight>(ReaderHighlight.none);
  final _paraKeys = <int, GlobalKey<ParagraphViewState>>{};

  Book? _book;
  List<Chapter> _chapters = const [];
  ChapterText? _chapterText;
  int _chapterIdx = 0;
  Object? _error;
  bool _chrome = false;
  bool _userScrolling = false;
  Timer? _clearWord;

  int get _id => widget.bookId;
  TextRepository get _text => ref.read(textRepositoryProvider);
  ReadingPosition get _position =>
      ref.read(readingPositionProvider(_id).notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _clearWord?.cancel();
    _scroll.dispose();
    _highlight.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _position.flush();
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(bookRepositoryProvider);
      var book = await repo.getBook(_id);
      if (book == null) throw StateError('This book is no longer here.');
      await ref.read(importServiceProvider).ensureIndexed(book);
      book = (await repo.getBook(_id))!;
      final chapters = await _text.chapters(_id);
      final start = math.min(
        book.currentSentence,
        math.max(0, book.sentenceCount - 1),
      );
      _position.restore(start);
      final chapterIdx = await _text.chapterIndexOf(_id, start);
      if (!mounted) return;
      setState(() {
        _book = book;
        _chapters = chapters;
      });
      await _showChapter(chapterIdx, sentence: start);
      unawaited(repo.markOpened(_id));
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  /// Loads a chapter and positions the view: at [sentence] if given, else
  /// the top (or the very end with [toEnd]).
  Future<void> _showChapter(
    int idx, {
    int? sentence,
    bool toEnd = false,
  }) async {
    final ct = await _text.loadChapter(_id, idx);
    if (!mounted) return;
    setState(() {
      _chapterIdx = idx;
      _chapterText = ct;
      _paraKeys.clear();
    });
    if (sentence == null && !toEnd) {
      _position.set(ct.chapter.firstSentence);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (sentence != null) {
        scrollToSentence(sentence, alignment: 0.06, animate: false);
      } else if (_scroll.hasClients) {
        _scroll.jumpTo(toEnd ? _scroll.position.maxScrollExtent : 0);
      }
    });
  }

  GlobalKey<ParagraphViewState> _keyFor(int paragraphIdx) =>
      _paraKeys.putIfAbsent(paragraphIdx, GlobalKey.new);

  /// Scrolls so sentence [idx] sits at [alignment] (0 = top, 1 = bottom)
  /// of the viewport. Used for restoring position and read-aloud follow.
  void scrollToSentence(
    int idx, {
    double alignment = 0.4,
    bool animate = true,
  }) {
    final ct = _chapterText;
    if (ct == null || !_scroll.hasClients) return;
    final para = ct.paragraphs
        .where((p) => p.sentences.any((s) => s.idx == idx))
        .firstOrNull;
    final rect = para == null
        ? null
        : _paraKeys[para.paragraph.idx]?.currentState?.sentenceRect(idx);
    final viewport =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (rect == null || viewport == null) return;
    final top = viewport.localToGlobal(Offset.zero).dy;
    final target = top + viewport.size.height * alignment;
    final offset = (_scroll.offset + rect.top - target).clamp(
      0.0,
      _scroll.position.maxScrollExtent,
    );
    if (animate) {
      _scroll.animateTo(
        offset,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    } else {
      _scroll.jumpTo(offset);
    }
  }

  /// The first sentence still (at least partly) visible at the top.
  int? _firstVisibleSentence() {
    final ct = _chapterText;
    final viewport =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (ct == null || viewport == null) return null;
    final y = viewport.localToGlobal(Offset.zero).dy + 12;
    for (final p in ct.paragraphs) {
      final state = _paraKeys[p.paragraph.idx]?.currentState;
      final id = state?.firstSentenceBelow(y);
      if (id != null) return id;
    }
    return null;
  }

  bool _onScroll(ScrollNotification n) {
    if (n is ScrollStartNotification && n.dragDetails != null) {
      _userScrolling = true;
    } else if (n is ScrollEndNotification && _userScrolling) {
      _userScrolling = false;
      _reportVisiblePosition();
    }
    return false;
  }

  void _reportVisiblePosition() {
    final id = _firstVisibleSentence();
    if (id != null) _position.set(id);
  }

  // --- page turning (paged mode) -------------------------------------------

  Future<void> _turnPage(int dir) async {
    if (!_scroll.hasClients) return;
    final s = ref.read(readerSettingsProvider);
    final pos = _scroll.position;
    final step = pos.viewportDimension - s.fontSize * s.lineHeight * 2.5;
    if (dir > 0 && pos.pixels >= pos.maxScrollExtent - 4) {
      if (_chapterIdx + 1 < _chapters.length) {
        await _showChapter(_chapterIdx + 1);
      }
      return;
    }
    if (dir < 0 && pos.pixels <= 4) {
      if (_chapterIdx > 0) await _showChapter(_chapterIdx - 1, toEnd: true);
      return;
    }
    await _scroll.animateTo(
      (pos.pixels + dir * step).clamp(0.0, pos.maxScrollExtent),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
    _reportVisiblePosition();
  }

  // --- interaction ---------------------------------------------------------

  void _toggleChrome() => setState(() => _chrome = !_chrome);

  void _onWordTap(WordHit hit) {
    // The lookup sheet attaches here; for now just show what was hit.
    _highlight.value = ReaderHighlight(
      sentence: hit.sentenceIdx,
      wordSentence: hit.sentenceIdx,
      wordStart: hit.token.start,
      wordEnd: hit.token.end,
    );
    _clearWord?.cancel();
    _clearWord = Timer(const Duration(milliseconds: 900), () {
      _highlight.value = ReaderHighlight.none;
    });
  }

  Future<void> _onSentenceLongPress(int idx, Offset at) async {
    final sentence = await _text.sentenceAt(_id, idx);
    if (sentence == null || !mounted) return;
    _highlight.value = ReaderHighlight(sentence: idx);
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                sentence.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: sentence.content));
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      ),
    );
    if (mounted) _highlight.value = ReaderHighlight.none;
  }

  Future<void> _jumpToPercent() async {
    final book = _book;
    if (book == null || book.sentenceCount == 0) return;
    var pct = ref.read(readingPositionProvider(_id)) / book.sentenceCount;
    final target = await showDialog<double>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: Text('Jump to ${(pct * 100).round()}%'),
          content: Slider(
            value: pct,
            onChanged: (v) => setLocal(() => pct = v),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, pct),
              child: const Text('Go'),
            ),
          ],
        ),
      ),
    );
    if (target != null) await _jumpToFraction(target);
  }

  Future<void> _jumpToFraction(double fraction) async {
    final book = _book;
    if (book == null || book.sentenceCount == 0) return;
    final idx = (fraction * (book.sentenceCount - 1)).round().clamp(
      0,
      book.sentenceCount - 1,
    );
    await _jumpToSentence(idx);
  }

  Future<void> _jumpToSentence(int idx) async {
    final chapter = await _text.chapterIndexOf(_id, idx);
    _position.set(idx);
    await _showChapter(chapter, sentence: idx);
  }

  void _openSettings() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const ReaderSettingsSheet(),
  );

  // --- build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(readerSettingsProvider);
    final palette = ReaderPalette.of(
      settings.theme,
      MediaQuery.platformBrightnessOf(context),
    );

    // Re-anchor on the current sentence when the layout changes under us.
    ref.listen(readerSettingsProvider, (prev, next) {
      if (prev == null || _chapterText == null) return;
      final relayout =
          prev.fontSize != next.fontSize ||
          prev.lineHeight != next.lineHeight ||
          prev.margin != next.margin ||
          prev.font != next.font ||
          prev.justified != next.justified;
      if (relayout) {
        final at = ref.read(readingPositionProvider(_id));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) scrollToSentence(at, alignment: 0.06, animate: false);
        });
      }
    });

    return PopScope(
      onPopInvokedWithResult: (_, _) => _position.flush(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: palette.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
              ),
        child: Scaffold(
          backgroundColor: palette.background,
          drawer: _chapterDrawer(),
          body: _body(settings, palette),
        ),
      ),
    );
  }

  Widget _body(ReaderSettings settings, ReaderPalette palette) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('$_error', style: TextStyle(color: palette.text)),
        ),
      );
    }
    final ct = _chapterText;
    if (ct == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: palette.accent),
            const SizedBox(height: 16),
            Text(
              'Preparing your book…',
              style: TextStyle(color: palette.secondary),
            ),
          ],
        ),
      );
    }

    final media = MediaQuery.of(context);
    final paged = settings.mode == ReadingMode.paged;
    // Taps that land on no word (margins, gaps between paragraphs) show or
    // hide the toolbars; words inside paragraphs win the gesture first.
    final content = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleChrome,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: SingleChildScrollView(
          key: _viewportKey,
          controller: _scroll,
          physics: paged ? const NeverScrollableScrollPhysics() : null,
          padding: EdgeInsets.fromLTRB(
            settings.margin,
            media.padding.top + 28,
            settings.margin,
            media.padding.bottom + 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_chapterIdx > 0)
                _ChapterLink(
                  label: 'Previous: ${_chapters[_chapterIdx - 1].title}',
                  icon: Icons.keyboard_arrow_up,
                  palette: palette,
                  onTap: () => _showChapter(_chapterIdx - 1),
                ),
              for (final p in ct.paragraphs)
                ParagraphView(
                  key: _keyFor(p.paragraph.idx),
                  paragraph: p,
                  settings: settings,
                  palette: palette,
                  highlight: _highlight,
                  onWordTap: _onWordTap,
                  onBlankTap: _toggleChrome,
                  onSentenceLongPress: _onSentenceLongPress,
                ),
              if (_chapterIdx + 1 < _chapters.length)
                _ChapterLink(
                  label: 'Next: ${_chapters[_chapterIdx + 1].title}',
                  icon: Icons.keyboard_arrow_down,
                  palette: palette,
                  onTap: () => _showChapter(_chapterIdx + 1),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'The end',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: palette.secondary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: paged
              ? GestureDetector(
                  onHorizontalDragEnd: (d) {
                    final v = d.primaryVelocity ?? 0;
                    if (v < -150) _turnPage(1);
                    if (v > 150) _turnPage(-1);
                  },
                  child: content,
                )
              : content,
        ),
        _topBar(palette),
        _bottomBar(palette, paged),
      ],
    );
  }

  Widget _topBar(ReaderPalette palette) {
    final title = _chapters.isEmpty ? '' : _chapters[_chapterIdx].title;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: !_chrome,
        child: AnimatedOpacity(
          opacity: _chrome ? 1 : 0,
          duration: const Duration(milliseconds: 160),
          child: Material(
            color: palette.background.withValues(alpha: 0.97),
            elevation: 2,
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  BackButton(color: palette.text),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _book?.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: palette.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: palette.secondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      tooltip: 'Chapters',
                      color: palette.text,
                      icon: const Icon(Icons.list),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Jump to…',
                    color: palette.text,
                    icon: const Icon(Icons.percent),
                    onPressed: _jumpToPercent,
                  ),
                  IconButton(
                    tooltip: 'Appearance',
                    color: palette.text,
                    icon: const Icon(Icons.text_fields),
                    onPressed: _openSettings,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar(ReaderPalette palette, bool paged) {
    final book = _book;
    final position = ref.watch(readingPositionProvider(_id));
    final total = math.max(1, book?.sentenceCount ?? 1);
    final fraction = (position / total).clamp(0.0, 1.0);
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        ignoring: !_chrome,
        child: AnimatedOpacity(
          opacity: _chrome ? 1 : 0,
          duration: const Duration(milliseconds: 160),
          child: Material(
            color: palette.background.withValues(alpha: 0.97),
            elevation: 2,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Row(
                  children: [
                    if (paged)
                      IconButton(
                        color: palette.text,
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => _turnPage(-1),
                      ),
                    Expanded(
                      child: Slider(
                        value: fraction,
                        activeColor: palette.accent,
                        onChanged: (v) =>
                            _position.set((v * (total - 1)).round()),
                        onChangeEnd: _jumpToFraction,
                      ),
                    ),
                    SizedBox(
                      width: 44,
                      child: Text(
                        '${(fraction * 100).round()}%',
                        textAlign: TextAlign.end,
                        style: TextStyle(color: palette.secondary),
                      ),
                    ),
                    if (paged)
                      IconButton(
                        color: palette.text,
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => _turnPage(1),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chapterDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Chapters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _chapters.length,
                itemBuilder: (context, i) => ListTile(
                  dense: true,
                  selected: i == _chapterIdx,
                  title: Text(
                    _chapters[i].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _position.set(_chapters[i].firstSentence);
                    _showChapter(i);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterLink extends StatelessWidget {
  const _ChapterLink({
    required this.label,
    required this.icon,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final ReaderPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: palette.accent),
      label: Text(
        label,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: palette.secondary),
      ),
    ),
  );
}
