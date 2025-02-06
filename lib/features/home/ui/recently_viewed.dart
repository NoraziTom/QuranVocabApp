import 'package:flutter/material.dart';

class RecentlyViewed extends StatelessWidget {
  const RecentlyViewed({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'وَرَحْمَتِ',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        }),
      ),
    );
  }
}