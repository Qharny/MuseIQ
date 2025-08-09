import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _skipToHome() {
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skipToHome,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView Content
              Expanded(
                flex: 4,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [
                      _buildOnboardingPage(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        iconData: Icons.headphones_rounded,
                        title: 'AI-Powered Music',
                        description:
                            'Experience intelligent music discovery\nwith advanced AI algorithms that\nunderstand your unique taste.',
                        gradientColors: [
                          const Color(0xFF00E5FF),
                          const Color(0xFF3F51B5),
                        ],
                      ),
                      _buildOnboardingPage(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        iconData: Icons.psychology_rounded,
                        title: 'Personalized Playlists',
                        description:
                            'AI curates perfect playlists based on\nyour listening history, preferences,\nand current mood.',
                        gradientColors: [
                          const Color(0xFF3F51B5),
                          const Color(0xFF9C27B0),
                        ],
                      ),
                      _buildOnboardingPage(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        iconData: Icons.favorite_rounded,
                        title: 'Mood-Based Recommendations',
                        description:
                            'Get music recommendations that match\nyour emotions and activities throughout\nthe day automatically.',
                        gradientColors: [
                          const Color(0xFF9C27B0),
                          const Color(0xFFE91E63),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Page Indicators
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? const Color(0xFF00E5FF)
                            : Colors.white.withOpacity(0.3),
                      ),
                    );
                  }),
                ),
              ),

              // Next/Get Started Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E5FF),
                      foregroundColor: Colors.black,
                      elevation: 8,
                      shadowColor: const Color(0xFF00E5FF).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required double screenWidth,
    required double screenHeight,
    required IconData iconData,
    required String title,
    required String description,
    required List<Color> gradientColors,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Container
          Container(
            width: screenWidth * 0.6,
            height: screenWidth * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background pattern
                ...List.generate(3, (index) {
                  return Positioned(
                    child: Container(
                      width: (screenWidth * 0.6) - (index * 40),
                      height: (screenWidth * 0.6) - (index * 40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1 - (index * 0.02)),
                          width: 1,
                        ),
                      ),
                    ),
                  );
                }),

                // Main Icon
                Icon(iconData, size: screenWidth * 0.2, color: Colors.white),

                // Floating music notes (decorative)
                if (iconData == Icons.headphones_rounded) ...[
                  Positioned(
                    top: 30,
                    right: 30,
                    child: Icon(
                      Icons.music_note,
                      size: 20,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 40,
                    child: Icon(
                      Icons.music_note,
                      size: 16,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],

                // AI Brain decoration
                if (iconData == Icons.psychology_rounded) ...[
                  Positioned(
                    top: 25,
                    left: 25,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 35,
                    right: 35,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.08),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
              height: 1.2,
            ),
          ),

          SizedBox(height: screenHeight * 0.03),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative version using actual SVG/PNG assets
// (Use this if you have actual image assets)
class OnboardingScreenWithAssets extends StatefulWidget {
  const OnboardingScreenWithAssets({Key? key}) : super(key: key);

  @override
  State<OnboardingScreenWithAssets> createState() =>
      _OnboardingScreenWithAssetsState();
}

class _OnboardingScreenWithAssetsState extends State<OnboardingScreenWithAssets>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;

  // Define your asset paths here
  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      // assetPath: 'assets/images/headphones.svg', // or .png
      title: 'AI-Powered Music',
      description:
          'Experience intelligent music discovery\nwith advanced AI algorithms that\nunderstand your unique taste.',
      iconData: Icons.headphones_rounded, // fallback
    ),
    OnboardingData(
      // assetPath: 'assets/images/ai_brain.svg',
      title: 'Personalized Playlists',
      description:
          'AI curates perfect playlists based on\nyour listening history, preferences,\nand current mood.',
      iconData: Icons.psychology_rounded,
    ),
    OnboardingData(
      // assetPath: 'assets/images/mood_music.svg',
      title: 'Mood-Based Recommendations',
      description:
          'Get music recommendations that match\nyour emotions and activities throughout\nthe day automatically.',
      iconData: Icons.favorite_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildAssetImage(OnboardingData data, double size) {
    // Uncomment and modify this when you have actual assets
    /*
    if (data.assetPath.endsWith('.svg')) {
      return SvgPicture.asset(
        data.assetPath,
        width: size,
        height: size,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    } else {
      return Image.asset(
        data.assetPath,
        width: size,
        height: size,
      );
    }
    */

    // Fallback to icon for now
    return Icon(data.iconData, size: size * 0.4, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    // Similar structure as the main onboarding screen
    // but with _buildAssetImage() instead of Icon widgets
    return const OnboardingScreen(); // Use the main implementation for now
  }
}

class OnboardingData {
  final String? assetPath;
  final String title;
  final String description;
  final IconData iconData;

  OnboardingData({
    this.assetPath,
    required this.title,
    required this.description,
    required this.iconData,
  });
}

