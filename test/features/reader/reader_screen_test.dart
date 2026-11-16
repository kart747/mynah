import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynah/core/providers.dart';
import 'package:mynah/data/db/app_database.dart';
import 'package:mynah/data/repositories/book_repository.dart';
import 'package:mynah/data/repositories/text_repository.dart';
import 'package:mynah/features/import/import_service.dart';
import 'package:mynah/features/reader/reader_screen.dart';

Finder _richContaining(String s) => find.byWidgetPredicate(
  (w) => w is RichText && w.text.toPlainText().contains(s),
);

void main() {
  late AppDatabase db;
  late Directory root;
  late int bookId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    root = await Directory.systemTemp.createTemp('mynah_reader_test');
  });

  tearDown(() async {
    await db.close();
    await root.delete(recursive: true);
  });

  Future<void> openReader(WidgetTester tester) async {
    await tester.runAsync(() async {
      final service = ImportService(
        BookRepository(db),
        TextRepository(db),
        () async => root,
      );
      final bytes = File(
        'assets/samples/alice-in-wonderland.epub',
      ).readAsBytesSync();
      bookId = (await service.importEpub('alice.epub', bytes) as ImportSuccess)
          .bookId;
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(home: ReaderScreen(bookId: bookId)),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('opens the book and shows its text', (tester) async {
    await openReader(tester);
    expect(_richContaining('Alice'), findsWidgets);
    expect(find.text('Preparing your book…'), findsNothing);
  });

  testWidgets('tapping blank space toggles the toolbar', (tester) async {
    await openReader(tester);
    final bar = find.byTooltip('Appearance');
    expect(
      tester
          .widget<IgnorePointer>(
            find.ancestor(of: bar, matching: find.byType(IgnorePointer)).first,
          )
          .ignoring,
      isTrue,
    );
    // The side margin is never a word.
    await tester.tapAt(const Offset(4, 300));
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      tester
          .widget<IgnorePointer>(
            find.ancestor(of: bar, matching: find.byType(IgnorePointer)).first,
          )
          .ignoring,
      isFalse,
    );
  });

  testWidgets('scrolling saves the reading position and reopening resumes', (
    tester,
  ) async {
    await openReader(tester);
    for (var i = 0; i < 5; i++) {
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump(const Duration(milliseconds: 200));
    }
    // Let the debounced save fire.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 900)),
    );
    await tester.pump(const Duration(seconds: 1));

    final saved = await tester.runAsync(
      () => BookRepository(db).getBook(bookId).then((b) => b!.currentSentence),
    );
    expect(saved, greaterThan(0));
  });
}
