import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../data/repositories/book_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/text_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepository(ref.watch(databaseProvider)),
);

final textRepositoryProvider = Provider<TextRepository>(
  (ref) => TextRepository(ref.watch(databaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);
