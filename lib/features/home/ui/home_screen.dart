import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'recently_viewed.dart';
import 'suggested_words.dart';
import 'did_you_know.dart';
import 'package:quranvocabapp/shared/widgets/bottom_nav_bar.dart'; // Import the modularized BottomNavigationBar
import '../../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'مُفْرَدَاتُ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            Text(
              'Quran Vocab Mastery',
              style: TextStyle(fontSize: 18, color: Colors.teal),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.teal),
            onPressed: () {
              // Help action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Search Bar
                SearchBar(),

                SizedBox(height: 16),

                // Recently Viewed Section
                Text(
                  'Recently Viewed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                RecentlyViewed(),

                SizedBox(height: 16),

                // Suggested Words Section
                SuggestedWords(),
              ],
            ),
          ),

          // Did You Know Section anchored at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: const DidYouKnow(),
            ),
          ),
        ],
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