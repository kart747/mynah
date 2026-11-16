import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/book_progress.dart';
import 'book_card.dart';
import 'library_providers.dart';

/// Opened from the library until the reader lands; shows what was imported.
class BookDetailsScreen extends ConsumerWidget {
  const BookDetailsScreen({super.key, required this.bookId});

  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookProvider(bookId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: book.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (book) {
          if (book == null) {
            return const Center(child: Text('This book is no longer here.'));
          }
          final minutes = book.minutesLeft();
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: SizedBox(
                  width: 180,
                  child: BookCard(book: book, onTap: () {}),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '~${book.wordCount} words'
                '${minutes == null ? '' : ' · ${formatTimeLeft(minutes)}'}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'The reader is coming next.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
