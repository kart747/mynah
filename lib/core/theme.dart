import 'package:flutter/material.dart';

/// Warm brown with a hint of the mynah's yellow beak.
const _seed = Color(0xFF7A5A2E);

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
