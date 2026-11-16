import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

enum ReaderTheme { system, light, sepia, dark }

enum ReaderFont { serif, sans, mono }

enum ReadingMode { scroll, paged }

/// Look and layout of the reader. Persisted as JSON.
class ReaderSettings {
  const ReaderSettings({
    this.theme = ReaderTheme.system,
    this.font = ReaderFont.serif,
    this.fontSize = 19,
    this.lineHeight = 1.6,
    this.margin = 22,
    this.justified = false,
    this.mode = ReadingMode.scroll,
  });

  final ReaderTheme theme;
  final ReaderFont font;
  final double fontSize;
  final double lineHeight;

  /// Horizontal page margin in logical pixels.
  final double margin;
  final bool justified;
  final ReadingMode mode;

  static const minFontSize = 13.0;
  static const maxFontSize = 34.0;
  static const minLineHeight = 1.2;
  static const maxLineHeight = 2.2;
  static const minMargin = 8.0;
  static const maxMargin = 56.0;

  ReaderSettings copyWith({
    ReaderTheme? theme,
    ReaderFont? font,
    double? fontSize,
    double? lineHeight,
    double? margin,
    bool? justified,
    ReadingMode? mode,
  }) => ReaderSettings(
    theme: theme ?? this.theme,
    font: font ?? this.font,
    fontSize: (fontSize ?? this.fontSize).clamp(minFontSize, maxFontSize),
    lineHeight: (lineHeight ?? this.lineHeight).clamp(
      minLineHeight,
      maxLineHeight,
    ),
    margin: (margin ?? this.margin).clamp(minMargin, maxMargin),
    justified: justified ?? this.justified,
    mode: mode ?? this.mode,
  );

  Map<String, dynamic> toJson() => {
    'theme': theme.name,
    'font': font.name,
    'fontSize': fontSize,
    'lineHeight': lineHeight,
    'margin': margin,
    'justified': justified,
    'mode': mode.name,
  };

  factory ReaderSettings.fromJson(Map<String, dynamic> json) {
    T pick<T extends Enum>(List<T> values, Object? name, T fallback) =>
        values.where((v) => v.name == name).firstOrNull ?? fallback;
    const d = ReaderSettings();
    return d.copyWith(
      theme: pick(ReaderTheme.values, json['theme'], d.theme),
      font: pick(ReaderFont.values, json['font'], d.font),
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      lineHeight: (json['lineHeight'] as num?)?.toDouble(),
      margin: (json['margin'] as num?)?.toDouble(),
      justified: json['justified'] as bool?,
      mode: pick(ReadingMode.values, json['mode'], d.mode),
    );
  }

  String? get fontFamily => switch (font) {
    ReaderFont.serif => 'serif',
    ReaderFont.sans => null,
    ReaderFont.mono => 'monospace',
  };

  @override
  bool operator ==(Object other) =>
      other is ReaderSettings &&
      other.theme == theme &&
      other.font == font &&
      other.fontSize == fontSize &&
      other.lineHeight == lineHeight &&
      other.margin == margin &&
      other.justified == justified &&
      other.mode == mode;

  @override
  int get hashCode =>
      Object.hash(theme, font, fontSize, lineHeight, margin, justified, mode);
}

/// Colours for one reader theme.
class ReaderPalette {
  const ReaderPalette({
    required this.background,
    required this.text,
    required this.secondary,
    required this.accent,
    required this.brightness,
  });

  final Color background;
  final Color text;
  final Color secondary;
  final Color accent;
  final Brightness brightness;

  Color get sentenceHighlight => accent.withValues(alpha: 0.16);
  Color get wordHighlight => accent.withValues(alpha: 0.42);

  static const light = ReaderPalette(
    background: Color(0xFFFCFAF6),
    text: Color(0xFF1C1B19),
    secondary: Color(0xFF6B665E),
    accent: Color(0xFFB07A12),
    brightness: Brightness.light,
  );
  static const sepia = ReaderPalette(
    background: Color(0xFFF4ECD8),
    text: Color(0xFF4A3A2A),
    secondary: Color(0xFF8A7560),
    accent: Color(0xFFB5651D),
    brightness: Brightness.light,
  );
  static const dark = ReaderPalette(
    background: Color(0xFF121212),
    text: Color(0xFFD6D2CA),
    secondary: Color(0xFF8E8A82),
    accent: Color(0xFFE0A83A),
    brightness: Brightness.dark,
  );

  static ReaderPalette of(ReaderTheme theme, Brightness system) =>
      switch (theme) {
        ReaderTheme.light => light,
        ReaderTheme.sepia => sepia,
        ReaderTheme.dark => dark,
        ReaderTheme.system => system == Brightness.dark ? dark : light,
      };
}

class ReaderSettingsController extends Notifier<ReaderSettings> {
  static const _key = 'reader';
  Timer? _save;

  @override
  ReaderSettings build() {
    ref.onDispose(() => _save?.cancel());
    _load();
    return const ReaderSettings();
  }

  Future<void> _load() async {
    final json = await ref.read(settingsRepositoryProvider).getJson(_key);
    if (json != null && ref.mounted) state = ReaderSettings.fromJson(json);
  }

  void update(ReaderSettings Function(ReaderSettings) change) {
    state = change(state);
    _save?.cancel();
    _save = Timer(const Duration(milliseconds: 400), () {
      ref.read(settingsRepositoryProvider).setJson(_key, state.toJson());
    });
  }
}

final readerSettingsProvider =
    NotifierProvider<ReaderSettingsController, ReaderSettings>(
      ReaderSettingsController.new,
    );
