import 'package:flutter/material.dart';

/// Muted cloth-binding colours; one is picked per title so a book always
/// gets the same cover.
const _bindings = [
  Color(0xFF5B3A29),
  Color(0xFF2F4858),
  Color(0xFF3E5641),
  Color(0xFF6B2D3C),
  Color(0xFF4A4063),
  Color(0xFF7A5A2E),
  Color(0xFF2E4A62),
  Color(0xFF59503F),
];

/// Typographic cover for books without an embedded cover image.
class GeneratedCover extends StatelessWidget {
  const GeneratedCover({super.key, required this.title, this.author});

  final String title;
  final String? author;

  @override
  Widget build(BuildContext context) {
    final base = _bindings[_stableHash(title) % _bindings.length];
    const ink = Color(0xFFF3E9D2);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [base, Color.lerp(base, Colors.black, 0.35)!],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 1.5, color: ink.withValues(alpha: 0.6)),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ink,
                  fontFamily: 'serif',
                  fontSize: 15,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (author != null)
              Text(
                author!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ink.withValues(alpha: 0.85),
                  fontFamily: 'serif',
                  fontSize: 11,
                ),
              ),
            const SizedBox(height: 10),
            Container(height: 1.5, color: ink.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}

/// String.hashCode isn't guaranteed stable across runs; this is.
int _stableHash(String s) {
  var h = 0;
  for (final c in s.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return h;
}
