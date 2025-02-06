import 'package:flutter/material.dart';
import 'package:quranvocabapp/features/home/ui/word_details_screen.dart';

import '../../../providers/word_provider.dart';

class SuggestedWords extends StatefulWidget {
  const SuggestedWords({super.key});

  @override
  State<SuggestedWords> createState() => _SuggestedWordsState();
}

class _SuggestedWordsState extends State<SuggestedWords> {
  final int totalPages = 7; // Total number of pages

  // Example data for different pages
  int currentPage = 0;
  List<Map<String, dynamic>> pageData = [];

  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  Future<void> _loadPageData() async {
    final words = await WordProvider.loadWordsAsMaps();
    setState(() {
      pageData = words.where((word) => word['id'] != -1).toList(); // ✅ Remove N/A words
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pageData.isEmpty) {
      return const Center(child: CircularProgressIndicator()); // Loading indicator
    }
    print(pageData); // Debug the current page's data

    // Get the current page's data
    final data = pageData[currentPage];
    print(data); // Debug the current page's data

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Suggested Words Title and Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Suggested Words',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Color(0xFF0097B2)),
              onPressed: () {
                // Navigate to a detailed list of all suggested words
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // GestureDetector wraps the Word Details Container
        GestureDetector(
          onTap: () {
            // Navigate to WordDetailsScreen with data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordDetailsScreen(
                  wordId: data['id'], // Pass only the word ID, fetch details inside WordDetailsScreen
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Translation and Meaning
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Translation:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['wordTranslation'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Transliteration:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['wordTransliteration'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Meaning:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['ayatTranslation'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arabic Word
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data['wordText'],
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Example Ayat:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: data['exampleAyat'],
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['surah'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),


              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Pagination Buttons (Full Width)
        Row(
          children: List.generate(totalPages, (index) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    currentPage = index; // Update the current page
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? const Color(0xFF0097B2)
                        : Colors.grey[300], // Highlight selected page
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${index + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                      currentPage == index ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}