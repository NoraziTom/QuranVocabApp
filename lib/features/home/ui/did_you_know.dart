import 'package:flutter/material.dart';

class DidYouKnow extends StatelessWidget {
  const DidYouKnow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Fixed height for the Did You Know section
      padding: const EdgeInsets.all(16),
      child: Center( // Center the contents both vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center within the Container
          crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center within the Column
          children: const [
            Text(
              'Did You Know?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "The word 'day' (yawm) appears 365 times in the Quran, "
                  "corresponding to the number of days in a year.",
              textAlign: TextAlign.center, // Center-align the text
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}