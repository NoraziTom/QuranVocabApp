import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom Arabic fonts

class QuranicTextHighlight extends StatelessWidget {
  final String fullText = 'وَرَحْمَتِى وَسِعَتْ كُلَّ شَىْءٍۢ';
  final String wordToHighlight = 'رَحْمَتِ';

  const QuranicTextHighlight({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quranic Highlight Example"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RichText(
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl, // Align text for Arabic
            text: TextSpan(
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontFamily: GoogleFonts.amiri().fontFamily, // Use Quranic font
              ),
              children: _getHighlightedText(fullText, wordToHighlight),
            ),
          ),
        ),
      ),
    );
  }

  /// Function to split and highlight a specific word in the Quranic text
  List<TextSpan> _getHighlightedText(String text, String highlight) {
    final List<TextSpan> spans = [];
    int start = 0;

    // Find the first occurrence of the substring
    while (start < text.length) {
      final index = text.indexOf(highlight, start);

      if (index < 0) {
        // Add the remaining text if no match is found
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      // Add the text before the highlighted substring
      if (start != index) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      // Add the highlighted substring with Quranic style
      spans.add(
        TextSpan(
          text: highlight,
          style: TextStyle(
            color: Colors.blue[600], // Subtle blue color
            backgroundColor: Colors.transparent, // No background highlight
            fontFamily: GoogleFonts.amiri().fontFamily, // Quranic Arabic font
          ),
        ),
      );

      // Update the start position
      start = index + highlight.length;
    }

    return spans;
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Quranic Highlight',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: QuranicTextHighlight(),
  ));
}
