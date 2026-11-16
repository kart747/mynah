import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/book_repository.dart';

class LibrarySortNotifier extends Notifier<LibrarySort> {
  @override
  LibrarySort build() => LibrarySort.lastOpened;

  void set(LibrarySort sort) => state = sort;
}

final librarySortProvider = NotifierProvider<LibrarySortNotifier, LibrarySort>(
  LibrarySortNotifier.new,
);

final libraryBooksProvider = StreamProvider<List<Book>>((ref) {
  final sort = ref.watch(librarySortProvider);
  return ref.watch(bookRepositoryProvider).watchBooks(sort);
});

final bookProvider = FutureProvider.family<Book?, int>(
  (ref, id) => ref.watch(bookRepositoryProvider).getBook(id),
);
