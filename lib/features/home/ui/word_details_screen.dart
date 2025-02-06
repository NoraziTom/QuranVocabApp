import 'package:flutter/material.dart';
import 'package:quranvocabapp/shared/widgets/bottom_nav_bar.dart'; // Import the modularized BottomNavigationBar
import 'package:quranvocabapp/shared/widgets/quranic_text_highlight.dart'; // Reuse QuranicTextHighlight
import 'package:quranvocabapp/models/word_model.dart';
import 'package:quranvocabapp/providers/word_provider.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests

class WordDetailsScreen extends StatefulWidget {
  final int wordId;

  const WordDetailsScreen({super.key, required this.wordId});

  @override
  WordDetailsScreenState createState() => WordDetailsScreenState(); // ✅ No Underscore
}

class WordDetailsScreenState extends State<WordDetailsScreen> { // ✅ No Underscore
  Word? wordDetails;
  List<String> relatedWords = []; // List to store related words
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWord();
  }

  Future<void> fetchRelatedWords(String baseWord) async {
    final String apiUrl = 'https://api.deepseek.com/v1/chat/completions';
    final String apiKey = 'sk-e5237b1ff42e4b7ab816019867f4bc6b'; // Replace with your actual DeepSeek API key

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json; charset=utf-8', // ✅ Ensure UTF-8 Encoding
        },
        body: jsonEncode({
          "model": "deepseek-chat",
          "messages": [
            {
              "role": "system",
              "content": "You are a helpful assistant. Provide a list of related Arabic root words for '$baseWord'."
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        // ✅ Decode response using UTF-8
        final decodedData = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(decodedData);

        // ✅ Extract the AI response text
        final String responseContent = data['choices'][0]['message']['content'];
        print("✅ Response Content: $responseContent");

        // ✅ Extract Arabic words using RegEx (ignoring explanations)
        final List<String> wordsList = RegExp(r'\*\*(.*?)\*\*')
            .allMatches(responseContent)
            .map((match) => match.group(1) ?? '')
            .toList();

        print("✅ Extracted Words: $wordsList");

        setState(() {
          relatedWords = wordsList; // Assign related words
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch related words: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("❌ Error fetching related words: $error");
    }
  }

  Future<void> _loadWord() async {
    print("Fetching word with ID: ${widget.wordId}");

    Word? word = await WordProvider.getWordById(widget.wordId);
    fetchRelatedWords(word!.wordText); // Fetch related words when widget initializes

    print("Fetched word: ${word.wordText}");

    if (mounted) {  // Prevent updating state after widget is disposed
      setState(() {
        wordDetails = word;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Word Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0), // Apply padding to the content inside the container
    child: Column(
        children: [
          // Section 1: Word Details
          Container(
            height: MediaQuery.of(context).size.height * 0.4,// 50% of screen height
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Word in Arabic
                Center(
                  child: Text(
                    wordDetails?.wordText ?? 'Loading...',  // ✅ Use `wordDetails.word`
                    style: const TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Translation, Root, Transliteration (in separate rows)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Translation Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                        children: [
                          const Text(
                            "Translation:",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wordDetails?.wordTranslation ?? 'Loading...',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Root Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Root:",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wordDetails?.wordRoot ?? 'Loading...',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Transliteration Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end, // Align content to the right
                        children: [
                          const Text(
                            "Transliteration:",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wordDetails?.wordTransliteration ?? 'Loading...',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                            textAlign: TextAlign.right, // right-align the text
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Highlighted Ayat Section
                Column(
                  children: [
                    QuranicTextHighlight(
                      fullText: wordDetails?.exampleAyat ?? 'Loading...',
                      highlight: wordDetails?.wordText ?? 'Loading...',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      wordDetails?.surah ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Meaning Section (Split Translation and Transliteration)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Translation:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wordDetails?.ayatTranslation ?? 'Loading...',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Transliteration:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wordDetails?.ayatTransliteration ?? 'Loading...',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.teal,
                            ),
                            textAlign: TextAlign.right, // right-align the text
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Section 2: Related Words and Actions
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.39, // 40% of screen height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Play Audio Button
                    Container(
                      width: 110,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 2), // Border styling
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                        color: Colors.grey[200], // Background color
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.teal),
                        onPressed: () {
                          // Play audio action
                        },
                      ),
                    ),
                    // Add to List Button
                    Container(
                      width: 110,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 2), // Border styling
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                        color: Colors.grey[200], // Background color
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.teal),
                        onPressed: () {
                          // Add to list action
                        },
                      ),
                    ),
                    // Share Button
                    Container(
                      width: 110,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 2), // Border styling
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                        color: Colors.grey[200], // Background color
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.teal),
                        onPressed: () {
                          // Share action
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                // Related Words Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Related Words:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.info_outline, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 8),

                // Loading indicator or related words grid
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Wrap(
                  spacing: 8, // Horizontal spacing between items
                  runSpacing: 8, // Vertical spacing between rows
                  children: List.generate(relatedWords.length, (index) {
                    return Container(
                      width: (MediaQuery.of(context).size.width - 64) / 3, // Ensure 3 columns
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.teal.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center( // Center-align the text
                        child: Text(
                          relatedWords[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
        ),
    ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0, // Set the active tab (e.g., Home)
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}