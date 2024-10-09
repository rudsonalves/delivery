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
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final italicRegex = RegExp(r'\*(.*?)\*');
    final colorScheme = Theme.of(context).colorScheme;
    final fontColor = color == null ? colorScheme.onSecondaryContainer : color;

    List<TextSpan> spans = [];
    int currentIndex = 0;

    while (currentIndex < text.length) {
      final boldMatch = boldRegex.matchAsPrefix(text, currentIndex);
      final italicMatch = italicRegex.matchAsPrefix(text, currentIndex);

      if (boldMatch != null &&
          (italicMatch == null || boldMatch.start < italicMatch.start)) {
        if (boldMatch.start > currentIndex) {
          spans.add(
              TextSpan(text: text.substring(currentIndex, boldMatch.start)));
        }
        spans.add(TextSpan(
          text: boldMatch.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
        currentIndex = boldMatch.end;
      } else if (italicMatch != null) {
        if (italicMatch.start > currentIndex) {
          spans.add(
              TextSpan(text: text.substring(currentIndex, italicMatch.start)));
        }
        spans.add(TextSpan(
          text: italicMatch.group(1),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
        currentIndex = italicMatch.end;
      } else {
        spans.add(TextSpan(text: text.substring(currentIndex)));
        break;
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: fontColor),
        children: spans,
      ),
    );
  }
}
