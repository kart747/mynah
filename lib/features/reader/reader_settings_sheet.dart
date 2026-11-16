import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reader_settings.dart';

/// Theme, font, size, spacing and layout controls. Changes apply live.
class ReaderSettingsSheet extends ConsumerWidget {
  const ReaderSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(readerSettingsProvider);
    void change(ReaderSettings Function(ReaderSettings) f) =>
        ref.read(readerSettingsProvider.notifier).update(f);

    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label('Theme'),
            SegmentedButton<ReaderTheme>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: ReaderTheme.system, label: Text('Auto')),
                ButtonSegment(value: ReaderTheme.light, label: Text('Light')),
                ButtonSegment(value: ReaderTheme.sepia, label: Text('Sepia')),
                ButtonSegment(value: ReaderTheme.dark, label: Text('Dark')),
              ],
              selected: {s.theme},
              onSelectionChanged: (v) =>
                  change((x) => x.copyWith(theme: v.first)),
            ),
            label('Font'),
            SegmentedButton<ReaderFont>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: ReaderFont.serif, label: Text('Serif')),
                ButtonSegment(value: ReaderFont.sans, label: Text('Sans')),
                ButtonSegment(value: ReaderFont.mono, label: Text('Mono')),
              ],
              selected: {s.font},
              onSelectionChanged: (v) =>
                  change((x) => x.copyWith(font: v.first)),
            ),
            label('Layout'),
            SegmentedButton<ReadingMode>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: ReadingMode.scroll, label: Text('Scroll')),
                ButtonSegment(value: ReadingMode.paged, label: Text('Pages')),
              ],
              selected: {s.mode},
              onSelectionChanged: (v) =>
                  change((x) => x.copyWith(mode: v.first)),
            ),
            _slider(
              'Text size',
              s.fontSize,
              ReaderSettings.minFontSize,
              ReaderSettings.maxFontSize,
              '${s.fontSize.round()}',
              (v) => change((x) => x.copyWith(fontSize: v)),
            ),
            _slider(
              'Line spacing',
              s.lineHeight,
              ReaderSettings.minLineHeight,
              ReaderSettings.maxLineHeight,
              s.lineHeight.toStringAsFixed(1),
              (v) => change((x) => x.copyWith(lineHeight: v)),
            ),
            _slider(
              'Margins',
              s.margin,
              ReaderSettings.minMargin,
              ReaderSettings.maxMargin,
              '${s.margin.round()}',
              (v) => change((x) => x.copyWith(margin: v)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Justify text'),
              value: s.justified,
              onChanged: (v) => change((x) => x.copyWith(justified: v)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider(
    String title,
    double value,
    double min,
    double max,
    String shown,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(shown)],
          ),
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}
