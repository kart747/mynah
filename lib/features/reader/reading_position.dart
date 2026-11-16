import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

/// The reader's position in a book: a global sentence index.
///
/// One source of truth shared by scrolling, read-aloud and AI context.
/// Changes are written to the database shortly after they settle; call
/// [flush] when the app pauses so nothing is lost.
class ReadingPosition extends Notifier<int> {
  ReadingPosition(this.bookId);

  final int bookId;
  Timer? _timer;
  int? _unsaved;

  @override
  int build() {
    ref.onDispose(() {
      _timer?.cancel();
      final pending = _unsaved;
      if (pending != null) {
        // Fire and forget: the provider is going away.
        ref.read(bookRepositoryProvider).savePosition(bookId, pending);
      }
    });
    return 0;
  }

  /// Sets the starting point without scheduling a save (loading a book).
  void restore(int sentenceIdx) => state = sentenceIdx;

  /// Moves to [sentenceIdx] and schedules a save.
  void set(int sentenceIdx) {
    if (sentenceIdx < 0 || sentenceIdx == state) return;
    state = sentenceIdx;
    _unsaved = sentenceIdx;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 600), flush);
  }

  /// Writes any pending position right now.
  Future<void> flush() async {
    _timer?.cancel();
    final pending = _unsaved;
    if (pending == null) return;
    _unsaved = null;
    await ref.read(bookRepositoryProvider).savePosition(bookId, pending);
  }
}

final readingPositionProvider =
    NotifierProvider.family<ReadingPosition, int, int>(ReadingPosition.new);
