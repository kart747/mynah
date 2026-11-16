import 'package:flutter_test/flutter_test.dart';
import 'package:mynah/core/text/sentence_splitter.dart';
import 'package:mynah/core/text/word_tokenizer.dart';

void main() {
  group('splitSentences', () {
    test('basic sentences', () {
      expect(splitSentences('It was late. She left! Did he follow?'), [
        'It was late.',
        'She left!',
        'Did he follow?',
      ]);
    });

    test('titles and initials do not split', () {
      expect(
        splitSentences(
          'Dr. Watson met Mr. Holmes and J. R. R. Tolkien. Then they left.',
        ),
        ['Dr. Watson met Mr. Holmes and J. R. R. Tolkien.', 'Then they left.'],
      );
    });

    test('e.g. / i.e. / a.m. / decimals stay inside a sentence', () {
      expect(
        splitSentences(
          'Use fruit, e.g. apples, at 6 a.m. daily, i.e. every day. Pi is 3.14 roughly.',
        ),
        [
          'Use fruit, e.g. apples, at 6 a.m. daily, i.e. every day.',
          'Pi is 3.14 roughly.',
        ],
      );
    });

    test('quotes: terminator inside quotes followed by a new sentence', () {
      expect(splitSentences('“Stop.” He ran. “Why?” she asked.'), [
        '“Stop.”',
        'He ran.',
        '“Why?” she asked.',
      ]);
    });

    test('lowercase after ? or ! continues the sentence', () {
      expect(splitSentences('"What?!" he said quietly. Fine.'), [
        '"What?!" he said quietly.',
        'Fine.',
      ]);
    });

    test('ellipses', () {
      expect(splitSentences('Well... I suppose so. He paused... Then left.'), [
        'Well... I suppose so.',
        'He paused...',
        'Then left.',
      ]);
      expect(splitSentences('Wait… what.'), ['Wait… what.']);
    });

    test('no terminal punctuation and whitespace are kept as one sentence', () {
      expect(splitSentences('  CHAPTER I.\n Down  the Rabbit-Hole '), [
        'CHAPTER I. Down the Rabbit-Hole',
      ]);
      expect(splitSentences('   '), isEmpty);
      expect(splitSentences('No ending here'), ['No ending here']);
    });

    test('concatenating sentences loses nothing but whitespace', () {
      const p =
          'Mr. Smith went to Washington. “Why?” he asked. It was 5 p.m. The end...';
      expect(splitSentences(p).join(' '), p);
    });
  });

  group('tokenizeWords', () {
    test('offsets, apostrophes and hyphens', () {
      final tokens = tokenizeWords('Don’t over-think it, Alice.');
      expect(tokens.map((t) => t.text), ['Don’t', 'over-think', 'it', 'Alice']);
      expect(tokens.first, const WordToken('Don’t', 0, 5));
      expect(
        'Don’t over-think it, Alice.'.substring(tokens[3].start, tokens[3].end),
        'Alice',
      );
    });

    test('normalizeWord', () {
      expect(normalizeWord('“Don’t,'), "don't");
      expect(normalizeWord('Alice.'), 'alice');
    });
  });
}
