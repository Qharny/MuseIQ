import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _loadingController;
  late AnimationController _waveController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _loadingAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _loadingController.repeat();
    _waveController.repeat();

    // Navigate after 3 seconds
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    Timer(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final bool isFirstTime = prefs.getBool('first_time') ?? true;

      if (isFirstTime) {
        // Mark as not first time
        await prefs.setBool('first_time', false);
        // Navigate to onboarding screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      } else {
        // Navigate to home screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _loadingController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A148C), // Deep purple
              Color(0xFF2C1810), // Dark purple-brown
              Color(0xFF0D0D0D), // Almost black
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_waveAnimation.value * 0.1),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF00E5FF), // Cyan
                            const Color(0xFF3F51B5), // Indigo
                            const Color(0xFF9C27B0), // Purple
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00E5FF).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.music_note_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // App Name
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'MuseIQ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Powered by Intelligence',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Loading Animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Animated Musical Notes
                  AnimatedBuilder(
                    animation: _loadingController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final delay = index * 0.3;
                          final animationValue =
                              (_loadingController.value + delay) % 1.0;
                          final opacity = (animationValue < 0.5)
                              ? animationValue * 2
                              : (1.0 - animationValue) * 2;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Opacity(
                              opacity: opacity,
                              child: Icon(
                                Icons.music_note,
                                size: 20,
                                color: Color.lerp(
                                  const Color(0xFF00E5FF),
                                  const Color(0xFF9C27B0),
                                  animationValue,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Circular Progress Indicator
                  // SizedBox(
                  //   width: 30,
                  //   height: 30,
                  //   child: CircularProgressIndicator(
                  //     strokeWidth: 3,
                  //     valueColor: AlwaysStoppedAnimation<Color>(
                  //       const Color(0xFF00E5FF),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 16),

                  // Loading Text
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
