import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import '../../home/ui/login_screen.dart'; // Import your HomeScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0097B2), // Background color (blue)
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Path to the image
          width: 150, // Adjust the width
        ),
      ),
    );
  }
}