import 'package:flutter/material.dart';
import 'package:museiq/screens/home_screen.dart';
import 'package:museiq/screens/onboard.dart';
import 'package:museiq/screens/splash.dart';

void main(){
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
      },
    );
  }
}

