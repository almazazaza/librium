import 'package:flutter/material.dart';

import 'package:librium/shared/widgets/linked_text.dart';

List<TextSpan> buildTextSpans({
  required String plainText,
  required List<String> links,
  required ThemeData theme
}) {
  List<TextSpan> spans = [];
  int currentIndex = 0;

  final sortedLinks = links
      .map((link) => MapEntry(link, plainText.indexOf(link)))
      .where((entry) => entry.value != -1)
      .toList()
    ..sort((a, b) => a.value.compareTo(b.value));

  for (var entry in sortedLinks) {
    final link = entry.key;
    final index = entry.value;

    if (index > currentIndex) {
      spans.add(TextSpan(text: plainText.substring(currentIndex, index)));
    }

    spans.add(LinkedTextSpan(
      text: link,
      url: link,
      color: theme.colorScheme.primary,
    ));

    currentIndex = index + link.length;
  }

  if (currentIndex < plainText.length) {
    spans.add(TextSpan(text: plainText.substring(currentIndex)));
  }

  return spans;
}