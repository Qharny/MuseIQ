import 'package:flutter/material.dart';
import 'package:museiq/screens/media_player_screen.dart';
import 'package:museiq/services/prefs_service.dart';
import 'package:museiq/widgets/mini_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fadeController;

  final List<String> _tabTitles = [
    'My Music',
    'Discover',
    'AI Assistant',
    'Playlists',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController.forward();

    // Restore last selected tab
    PrefsService.getLastHomeTabIndex().then((value) {
      if (!mounted) return;
      setState(() {
        _currentIndex = value;
      });
      _pageController.jumpToPage(value);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    PrefsService.setLastHomeTabIndex(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          _tabTitles[_currentIndex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.library_music, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/music-library');
            },
            tooltip: 'Music Library',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Implement notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.music_note, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/controls-demo');
            },
          ),
          IconButton(
            icon: const Icon(Icons.storage, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/storage-test');
            },
            tooltip: 'Storage Test',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          MusicTab(),
          DiscoverTab(),
          AssistantTab(),
          PlaylistsTab(),
          SettingsTab(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini Player
          const MiniPlayer(),
          // Bottom Navigation
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFF1A1A1A),
              selectedItemColor: const Color(0xFF4A148C),
              unselectedItemColor: Colors.grey[600],
              selectedFontSize: 12,
              unselectedFontSize: 12,
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music_outlined),
                  activeIcon: Icon(Icons.library_music),
                  label: 'Music',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome_outlined),
                  activeIcon: Icon(Icons.auto_awesome),
                  label: 'Discover',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mic_outlined),
                  activeIcon: Icon(Icons.mic),
                  label: 'Assistant',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder_outlined),
                  activeIcon: Icon(Icons.folder),
                  label: 'Playlists',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Music Tab - Shows library of songs/albums
class MusicTab extends StatelessWidget {
  const MusicTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recently Played Section
          const Text(
            'Recently Played',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildAlbumCard(
                    context,
                    'Album ${index + 1}',
                    'Artist Name',
                    Colors.primaries[index % Colors.primaries.length],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // All Songs Section
          const Text(
            'All Songs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _buildSongTile(
                context,
                'Song Title ${index + 1}',
                'Artist Name',
                '3:45',
                Colors.primaries[index % Colors.primaries.length],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumCard(
    BuildContext context,
    String title,
    String artist,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MusicPlayerScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(child: Icon(Icons.album, size: 50, color: color)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongTile(
    BuildContext context,
    String title,
    String artist,
    String duration,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.music_note, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '$artist • $duration',
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MusicPlayerScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Discover Tab - AI recommendations
class DiscoverTab extends StatelessWidget {
  const DiscoverTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Mood Detection
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A148C), Color(0xFF00E5FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'AI Mood Detection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Currently detecting: Energetic & Focused',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MusicPlayerScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4A148C),
                  ),
                  child: const Text('Generate Playlist'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Mood-based recommendations
          const Text(
            'For Your Current Mood',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final moods = [
                'Energetic',
                'Chill',
                'Focus',
                'Party',
                'Sleep',
                'Workout',
              ];
              final colors = [
                Colors.orange,
                Colors.blue,
                Colors.green,
                Colors.pink,
                Colors.purple,
                Colors.red,
              ];

              return _buildMoodCard(
                context,
                moods[index],
                '${15 + (index * 5)} songs',
                colors[index],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(
    BuildContext context,
    String mood,
    String songCount,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MusicPlayerScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(child: Icon(Icons.mood, size: 50, color: color)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mood,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      songCount,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MusicPlayerScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'Play',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Assistant Tab - Voice/Chat interface
class AssistantTab extends StatefulWidget {
  const AssistantTab({Key? key}) : super(key: key);

  @override
  State<AssistantTab> createState() => _AssistantTabState();
}

class _AssistantTabState extends State<AssistantTab> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Hi! I'm your AI music assistant. Ask me to play songs, recommend music, or create playlists!",
      isUser: false,
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: _messageController.text, isUser: true));
      _messages.add(
        ChatMessage(
          text: "I'd love to help you with that! This is a demo response.",
          isUser: false,
        ),
      );
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Quick Actions
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      'Surprise Me',
                      Icons.shuffle,
                      const Color(0xFF00E5FF),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      'Voice Command',
                      Icons.mic,
                      const Color(0xFF4A148C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Chat Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildChatBubble(_messages[index]);
            },
          ),
        ),

        // Message Input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ask me about music...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4A148C),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MusicPlayerScreen()),
        );
      },
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4A148C),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? const Color(0xFF4A148C)
                    : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF00E5FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

// Playlists Tab
class PlaylistsTab extends StatelessWidget {
  const PlaylistsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create New Playlist Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Create New Playlist'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A148C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Your Playlists',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) {
              final playlistNames = [
                'Liked Songs',
                'Workout Hits',
                'Chill Vibes',
                'Focus Flow',
                'Party Mix',
                'Sleep Sounds',
                'Road Trip',
                'Study Time',
              ];
              final songCounts = [156, 43, 67, 89, 92, 23, 78, 45];

              return _buildPlaylistTile(
                context,
                playlistNames[index % playlistNames.length],
                songCounts[index % songCounts.length],
                Colors.primaries[index % Colors.primaries.length],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(
    BuildContext context,
    String name,
    int songCount,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MusicPlayerScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.playlist_play, color: color, size: 30),
          ),
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            '$songCount songs',
            style: TextStyle(color: Colors.grey[400]),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

// Settings Tab
class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Features Section
          _buildSectionHeader('AI Features'),
          _buildSettingsTile(
            'Smart Recommendations',
            'Enable AI-powered music suggestions',
            Icons.psychology,
            true,
          ),
          _buildSettingsTile(
            'Mood Detection',
            'Automatically detect mood from activity',
            Icons.mood,
            true,
          ),
          _buildSettingsTile(
            'Voice Commands',
            'Control music with voice',
            Icons.mic,
            false,
          ),

          const SizedBox(height: 24),

          // Audio Settings
          _buildSectionHeader('Audio Settings'),
          _buildSettingsTile(
            'High Quality Audio',
            'Stream in highest quality available',
            Icons.high_quality,
            true,
          ),
          _buildSettingsTile(
            'Crossfade',
            'Smooth transitions between songs',
            Icons.tune,
            false,
          ),
          _buildSettingsTile(
            'Equalizer',
            'Customize sound preferences',
            Icons.equalizer,
            null,
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Account Settings
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            'Profile',
            'Manage your account information',
            Icons.person,
            null,
            onTap: () {},
          ),
          _buildSettingsTile(
            'Privacy',
            'Control data usage and privacy',
            Icons.privacy_tip,
            null,
            onTap: () {},
          ),
          _buildSettingsTile(
            'About',
            'App version and information',
            Icons.info,
            null,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    bool? switchValue, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4A148C)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
        trailing: switchValue != null
            ? Switch(
                value: switchValue,
                onChanged: (value) {},
                activeColor: const Color(0xFF4A148C),
              )
            : const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }
}
