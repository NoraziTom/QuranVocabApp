import 'package:xml/xml.dart';

class Word {
  final int id;
  final String wordText;
  final String wordTranslation;
  final String wordTransliteration;
  final String wordRoot;
  final String ayatTranslation;
  final String ayatTransliteration;
  final String exampleAyat;
  final String surah;
  final List<int> relatedWords;

  Word({
    required this.id,
    required this.wordText,
    required this.wordTranslation,
    required this.wordTransliteration,
    required this.wordRoot,
    required this.ayatTranslation,
    required this.ayatTransliteration,
    required this.exampleAyat,
    required this.surah,
    required this.relatedWords,
  });

  // ✅ Convert Word Object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wordText': wordText,
      'wordTranslation': wordTranslation,
      'wordTransliteration': wordTransliteration,
      'wordRoot': wordRoot,
      'ayatTranslation': ayatTranslation,
      'ayatTransliteration': ayatTransliteration,
      'exampleAyat': exampleAyat,
      'surah': surah,
      'relatedWords': relatedWords,
    };
  }

  // Factory method to parse XML data
  factory Word.fromXml(XmlElement element) {
    String getText(XmlElement element, String tag) {
      return element.findElements(tag).isNotEmpty
          ? element.findElements(tag).first.text
          : 'N/A';  // ✅ Avoids "Bad state: No element" error
    }

    return Word(
      id: int.tryParse(getText(element, 'id')) ?? -1,
      wordText: getText(element, 'wordText'),
      wordTranslation: getText(element, 'wordTranslation'),
      wordTransliteration: getText(element, 'wordTransliteration'),
      wordRoot: getText(element, 'wordRoot'),
      ayatTranslation: getText(element, 'ayatTranslation'),
      ayatTransliteration: getText(element, 'ayatTransliteration'),
      exampleAyat: getText(element, 'exampleAyat'),
      surah: getText(element, 'surah'),
      relatedWords: getText(element, 'relatedWords')
          .split(',')
          .map((id) => int.tryParse(id.trim()) ?? 0)
          .toList(),
    );
  }

}