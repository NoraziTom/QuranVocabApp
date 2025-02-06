import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';
import '../models/word_model.dart';

class WordProvider {
  static Future<List<Word>> loadWords() async {
    final xmlString = await rootBundle.loadString('assets/data.xml');
    final document = XmlDocument.parse(xmlString);

    final words = document.findAllElements('word').map((wordElement) {
      return Word.fromXml(wordElement);
    }).where((word) => word.id != -1).toList(); // ✅ Filter out invalid words

    print("✅ Final Words List: ${words.length}");
    return words;
  }

  // ✅ Convert Words to List of Maps for pageData
  static Future<List<Map<String, dynamic>>> loadWordsAsMaps() async {
    final words = await loadWords();
    return words.map((word) => word.toMap()).toList();
  }

  // Fetch a word by ID
  static Future<Word?> getWordById(int id) async {
    List<Word> words = await loadWords();

    try {
      return words.firstWhere((word) => word.id == id);
    } catch (e) {
      print("⚠️ Word not found for ID: $id");
      return null; // ✅ Return `null` instead of creating a fake Word
    }
  }

}