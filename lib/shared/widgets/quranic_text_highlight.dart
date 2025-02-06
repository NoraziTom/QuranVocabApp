import 'package:flutter/material.dart';

class QuranicTextHighlight extends StatelessWidget {
  final String fullText; // Full Quranic text
  final String highlight; // Substring to highlight

  const QuranicTextHighlight({
    super.key,
    required this.fullText,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl, // For proper Arabic alignment
      text: TextSpan(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'Amiri', // Optional: use a Quranic font
        ),
        children: _getHighlightedText(fullText, highlight),
      ),
    );
  }

  /// Splits the text and highlights the desired substring.
  List<TextSpan> _getHighlightedText(String text, String highlight) {
    final List<TextSpan> spans = [];
    int start = 0;

    while (start < text.length) {
      final index = text.indexOf(highlight, start);

      if (index < 0) {
        // Add remaining text if no match
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      // Add the text before the highlight
      if (start != index) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      // Add the highlighted text
      spans.add(
        TextSpan(
          text: highlight,
          style: const TextStyle(
            color: Colors.teal, // Highlight color
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      // Update the start position
      start = index + highlight.length;
    }

    return spans;
  }
}