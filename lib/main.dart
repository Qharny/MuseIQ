import 'package:flutter/material.dart';
import 'package:museiq/screens/controls_demo.dart';
import 'package:museiq/screens/home_screen.dart';
import 'package:museiq/screens/media_player_screen.dart';
import 'package:museiq/screens/music_library_screen.dart';
import 'package:museiq/screens/onboard.dart';
import 'package:museiq/screens/splash.dart';
import 'package:museiq/screens/storage_test_screen.dart';

void main() {
  runApp(const museiq());
}

class museiq extends StatelessWidget {
  const museiq({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Music Player',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/media-player': (context) => const MusicPlayerScreen(),
        '/music-library': (context) => const MusicLibraryScreen(),
        '/storage-test': (context) => const StorageTestScreen(),
        '/controls-demo': (context) => const ControlsDemoScreen(),
      },
    );
  }
}
