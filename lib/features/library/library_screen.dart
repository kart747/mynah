import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/book_repository.dart';
import '../import/import_controller.dart';
import '../import/import_service.dart';
import 'book_card.dart';
import 'library_providers.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  /// Hidden right away on swipe; Dismissible requires the item to leave the
  /// tree before the DB stream catches up.
  final _dismissed = <int>{};

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(libraryBooksProvider);
    final importing = ref.watch(importControllerProvider) > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mynah'),
        actions: [
          const _SortButton(),
          PopupMenuButton<VoidCallback>(
            onSelected: (action) => action(),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _addSamples,
                enabled: !importing,
                child: const Text('Add sample books'),
              ),
            ],
          ),
        ],
        bottom: importing
            ? const PreferredSize(
                preferredSize: Size.fromHeight(3),
                child: LinearProgressIndicator(minHeight: 3),
              )
            : null,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: importing ? null : _import,
        icon: const Icon(Icons.add),
        label: const Text('Import EPUB'),
      ),
      body: books.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load library.\n$e')),
        data: (all) {
          final visible =
              all.where((b) => !_dismissed.contains(b.id)).toList();
          if (visible.isEmpty) {
            return _EmptyLibrary(busy: importing, onAddSamples: _addSamples);
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 160,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              childAspectRatio: 0.48,
            ),
            itemCount: visible.length,
            itemBuilder: (context, i) => _dismissibleCard(visible[i]),
          );
        },
      ),
    );
  }

  Widget _dismissibleCard(Book book) {
    final colors = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(book.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.delete_outline, color: colors.onErrorContainer),
      ),
      confirmDismiss: (_) => _confirmDelete(book),
      onDismissed: (_) => _delete(book),
      child: BookCard(book: book, onTap: () => _open(book)),
    );
  }

  Future<void> _open(Book book) async {
    await ref.read(bookRepositoryProvider).markOpened(book.id);
    if (mounted) context.push('/book/${book.id}');
  }

  Future<bool> _confirmDelete(Book book) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete book?'),
        content: Text(
          '"${book.title}" and your progress in it will be removed '
          'from this phone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _delete(Book book) async {
    setState(() => _dismissed.add(book.id));
    await ref.read(importControllerProvider.notifier).deleteBook(book);
    _showMessage('Deleted "${book.title}"');
  }

  Future<void> _import() async {
    final results =
        await ref.read(importControllerProvider.notifier).pickAndImport();
    _report(results);
  }

  Future<void> _addSamples() async {
    final results =
        await ref.read(importControllerProvider.notifier).addSampleBooks();
    _report(results);
  }

  void _report(List<ImportResult> results) {
    final added = results.whereType<ImportSuccess>().toList();
    final duplicates = results.whereType<ImportDuplicate>().toList();
    final failures = results.whereType<ImportFailure>().toList();
    final lines = [
      if (added.length == 1) 'Added "${added.single.title}"',
      if (added.length > 1) 'Added ${added.length} books',
      if (duplicates.length == 1)
        '"${duplicates.single.existing.title}" is already in your library',
      if (duplicates.length > 1)
        '${duplicates.length} books were already in your library',
      for (final f in failures) 'Couldn\'t import ${f.fileName}: ${f.reason}',
    ];
    if (lines.isNotEmpty) _showMessage(lines.join('\n'));
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SortButton extends ConsumerWidget {
  const _SortButton();

  static const _labels = {
    LibrarySort.lastOpened: 'Last opened',
    LibrarySort.title: 'Title',
    LibrarySort.progress: 'Progress',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(librarySortProvider);
    return PopupMenuButton<LibrarySort>(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort',
      initialValue: current,
      onSelected: ref.read(librarySortProvider.notifier).set,
      itemBuilder: (_) => [
        for (final sort in LibrarySort.values)
          CheckedPopupMenuItem(
            value: sort,
            checked: sort == current,
            child: Text(_labels[sort]!),
          ),
      ],
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.busy, required this.onAddSamples});

  final bool busy;
  final VoidCallback onAddSamples;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_stories_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Your library is empty', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Import an EPUB from your phone, or start with two classics.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: busy ? null : onAddSamples,
              icon: const Icon(Icons.library_add_outlined),
              label: const Text('Add sample books'),
            ),
          ],
        ),
      ),
    );
  }
}
