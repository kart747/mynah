import 'package:flutter_test/flutter_test.dart';
import 'package:mynah/features/import/html_text.dart';

List<String> _paras(String html) =>
    htmlToParagraphs(html).map((p) => p.toString()).toList();

void main() {
  test('splits block elements and flattens inline ones', () {
    expect(
      _paras(
        '<html><head><title>T</title><style>p{}</style></head>'
        '<body><p>One <i>very</i>\n  big\tday.</p><div>Two</div></body></html>',
      ),
      ['One very big day.', 'Two'],
    );
  });

  test('marks headings and joins <br> lines', () {
    expect(
      _paras(
        '<h2><a id="c1"/>CHAPTER I.<br/>\nDown the Rabbit-Hole</h2>'
        '<p>Alice was tired.</p>',
      ),
      ['# CHAPTER I. Down the Rabbit-Hole', 'Alice was tired.'],
    );
  });

  test('decodes named and numeric entities', () {
    expect(
      _paras(
        '<p>Tom &amp; Jerry&nbsp;&mdash; &#8220;hi&#x201D; caf&eacute;'
        ' &unknown;</p>',
      ),
      ['Tom & Jerry — “hi” café &unknown;'],
    );
  });

  test('drops page-number markers, keeps surrounding text', () {
    expect(
      _paras(
        '<p>before <span class="pagenum"><a id="p12">[Pg 12]</a></span>'
        'after</p><p>x<span epub:type="pagebreak" title="13">13</span>y</p>',
      ),
      ['before after', 'xy'],
    );
  });

  test('ignores comments, CDATA text is kept, unclosed tags tolerated', () {
    expect(
      _paras('<!-- note --><p>a<![CDATA[ & b]]><p>c<script>var x=1;</script>'),
      ['a & b', 'c'],
    );
  });

  test('keeps a single-letter drop-cap image as text', () {
    expect(_paras('<p><img src="i.png" alt="T"/>he end.</p>'), ['The end.']);
  });

  test('nested lists and tables become separate paragraphs', () {
    expect(
      _paras(
        '<ul><li>a</li><li>b <b>c</b></li></ul>'
        '<table><tr><td>x</td><td>y</td></tr></table>',
      ),
      ['a', 'b c', 'x', 'y'],
    );
  });
}
