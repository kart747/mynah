import 'dart:convert';

import '../db/app_database.dart';

/// JSON values keyed by name, persisted in the app database.
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<Map<String, dynamic>?> getJson(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    try {
      final decoded = jsonDecode(row.value);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> setJson(String key, Map<String, dynamic> value) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: key, value: jsonEncode(value)),
      );
}
