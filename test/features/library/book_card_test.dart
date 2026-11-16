import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynah/data/db/app_database.dart';
import 'package:mynah/features/library/book_card.dart';
import 'package:mynah/features/library/generated_cover.dart';

Book _book({String? coverPath, int current = 0, int sentences = 0}) => Book(
  id: 1,
  title: 'The Moonstone',
  author: 'Wilkie Collins',
  format: BookFormat.epub,
  filePath: '/books/1.epub',
  coverPath: coverPath,
  fileSize: 1,
  wordCount: 2300,
  sentenceCount: sentences,
  currentSentence: current,
  status: ImportStatus.ready,
  addedAt: DateTime(2026),
);

Future<void> _pump(WidgetTester tester, Book book, {VoidCallback? onTap}) =>
    tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 140,
            height: 320,
            child: BookCard(book: book, onTap: onTap ?? () {}),
          ),
        ),
      ),
    );

void main() {
  testWidgets('shows title, author, progress and time left', (tester) async {
    await _pump(tester, _book(current: 50, sentences: 200));

    expect(find.text('Wilkie Collins'), findsWidgets);
    expect(find.text('25% · 8m left'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('falls back to a generated cover', (tester) async {
    await _pump(tester, _book());

    expect(find.byType(GeneratedCover), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.text('0% · 10m left'), findsOneWidget);
  });

  testWidgets('uses the generated cover when the image is missing', (
    tester,
  ) async {
    // File decoding needs real async I/O, which fake-async test time blocks.
    await tester.runAsync(() async {
      await _pump(tester, _book(coverPath: '/does/not/exist.jpg'));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();

    expect(find.byType(GeneratedCover), findsOneWidget);
  });

  testWidgets('tap calls onTap', (tester) async {
    var tapped = false;
    await _pump(tester, _book(), onTap: () => tapped = true);
    await tester.tap(find.byType(BookCard));
    expect(tapped, isTrue);
  });
}
