import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/book_progress.dart';
import '../../data/db/app_database.dart';
import 'generated_cover.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, required this.onTap});

  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (book.progress * 100).round();
    final minutes = book.minutesLeft();
    final meta = [
      '$percent%',
      if (minutes != null) formatTimeLeft(minutes),
    ].join(' · ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(6),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _cover(),
                  if (book.progress > 0)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator(
                        value: book.progress,
                        minHeight: 3,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600, height: 1.2),
          ),
          if (book.author != null)
            Text(
              book.author!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          Text(
            meta,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _cover() {
    final fallback = GeneratedCover(title: book.title, author: book.author);
    final path = book.coverPath;
    if (path == null) return fallback;
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      // Decode at thumbnail size; full-size covers waste memory in a grid.
      cacheWidth: 360,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}
