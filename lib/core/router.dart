import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/library/book_details_screen.dart';
import '../features/library/library_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const LibraryScreen(),
        routes: [
          GoRoute(
            path: 'book/:id',
            builder: (_, state) => BookDetailsScreen(
              bookId: int.parse(state.pathParameters['id']!),
            ),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
