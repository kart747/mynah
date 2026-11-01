import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynah/app.dart';
import 'package:mynah/core/providers.dart';
import 'package:mynah/data/db/app_database.dart';
import 'package:mynah/data/repositories/book_repository.dart';
import 'package:mynah/features/library/book_card.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      )));

  tearDown(() => db.close());

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MynahApp(),
    ));
    await tester.pumpAndSettle();
  }

  /// Unmount so Drift stream subscriptions are cancelled inside the test.
  Future<void> tearDownApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  Future<int> addBook(String title, {int current = 0}) =>
      BookRepository(db).addBook(BooksCompanion.insert(
        title: title,
        format: BookFormat.epub,
        filePath: '/nowhere/$title.epub',
        fileSize: title.length,
        wordCount: const Value(1000),
        sentenceCount: const Value(100),
        currentSentence: Value(current),
      ));

  testWidgets('shows the empty state with sample books offer',
      (tester) async {
    await pumpApp(tester);

    expect(find.text('Your library is empty'), findsOneWidget);
    expect(find.text('Add sample books'), findsOneWidget);
    expect(find.text('Import EPUB'), findsOneWidget);
    await tearDownApp(tester);
  });

  testWidgets('lists books and re-sorts by title', (tester) async {
    await addBook('Middlemarch', current: 10);
    await addBook('Emma', current: 90);
    await pumpApp(tester);

    expect(find.byType(BookCard), findsNWidgets(2));
    expect(find.text('90% · 1m left'), findsOneWidget);

    await tester.tap(find.byTooltip('Sort'));
    await tester.pumpAndSettle();
    await tester.tap(
        find.widgetWithText(CheckedPopupMenuItem<LibrarySort>, 'Title'));
    await tester.pumpAndSettle();

    final titles = tester
        .widgetList<BookCard>(find.byType(BookCard))
        .map((c) => c.book.title)
        .toList();
    expect(titles, ['Emma', 'Middlemarch']);
    await tearDownApp(tester);
  });

  testWidgets('swipe asks for confirmation; cancel keeps the book',
      (tester) async {
    await addBook('Emma');
    await pumpApp(tester);

    await tester.drag(find.byType(BookCard), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.text('Delete book?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(BookCard), findsOneWidget);
    await tearDownApp(tester);
  });

  testWidgets('swipe and confirm deletes the book', (tester) async {
    final id = await addBook('Emma');
    await pumpApp(tester);

    await tester.drag(find.byType(BookCard), const Offset(-400, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    // Deleting the stored files is real I/O.
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();

    expect(find.byType(BookCard), findsNothing);
    expect(find.text('Deleted "Emma"'), findsOneWidget);
    expect(await tester.runAsync(() => BookRepository(db).getBook(id)),
        isNull);
    await tearDownApp(tester);
  });
}
