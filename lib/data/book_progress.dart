import 'db/app_database.dart';

/// Average silent-reading speed used for time estimates until we have
/// the reader's own pace from stats.
const defaultWordsPerMinute = 230;

extension BookProgress on Book {
  /// Fraction read, 0.0–1.0.
  double get progress {
    if (sentenceCount <= 0) return 0;
    return (currentSentence / sentenceCount).clamp(0.0, 1.0);
  }

  /// Minutes left at [wordsPerMinute], or null while the word count is unknown.
  int? minutesLeft({int wordsPerMinute = defaultWordsPerMinute}) {
    if (wordCount <= 0) return null;
    final wordsLeft = wordCount * (1 - progress);
    return (wordsLeft / wordsPerMinute).ceil();
  }
}

/// "3h 20m left", "45m left", "<1m left".
String formatTimeLeft(int minutes) {
  if (minutes < 1) return '<1m left';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m left';
  if (m == 0) return '${h}h left';
  return '${h}h ${m}m left';
}
