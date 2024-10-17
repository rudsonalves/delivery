// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

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
