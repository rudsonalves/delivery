import 'package:flutter/material.dart';

class MarkdowntoRichText extends StatelessWidget {
  final String text;
  final Color? color;

  const MarkdowntoRichText({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fontColor = color ?? colorScheme.onSecondaryContainer;

    // Regex que detecta negrito (**xx**) ou itálico (*xx*)
    final combinedRegex = RegExp(r'(\*\*.*?\*\*)|(\*.*?\*)');

    List<TextSpan> spans = [];
    int currentIndex = 0;

    final matches = combinedRegex.allMatches(text);
    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }

      final matchedText = match.group(0)!;

      if (matchedText.startsWith('**') && matchedText.endsWith('**')) {
        spans.add(TextSpan(
          text: matchedText.substring(2, matchedText.length - 2),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (matchedText.startsWith('*') && matchedText.endsWith('*')) {
        spans.add(TextSpan(
          text: matchedText.substring(1, matchedText.length - 1),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
      }

      currentIndex = match.end;
    }

    // Adiciona o restante do texto (se houver)
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: fontColor),
        children: spans,
      ),
    );
  }
}
