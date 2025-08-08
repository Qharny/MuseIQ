import 'package:flutter/material.dart';
import 'package:museiq/models/song_model.dart';
import 'package:museiq/services/audio_service.dart';
import 'package:museiq/widgets/music_player_controls.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with TickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  late AnimationController _artworkController;
  late AnimationController _playButtonController;
  late Animation<double> _artworkAnimation;
  late Animation<double> _playButtonAnimation;

  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isLoop = false;
  bool _isLiked = false;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Current song data
  Song? _currentSong;
  String _songTitle = "AI Dreams";
  String _artistName = "Future Beats";
  String _albumArt = "assets/images/Music-amico.png";

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _artworkController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _artworkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _artworkController, curve: Curves.linear),
    );

    _playButtonAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.elasticOut),
    );

    _setupAudioPlayer();
    _updateCurrentSong();
  }

  void _setupAudioPlayer() {
    // Listen to position changes
    _audioService.positionStream.listen((position) {
      if (mounted && position != null) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    // Listen to duration changes
    _audioService.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    // Listen to player state changes
    _audioService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });

        if (_isPlaying) {
          _artworkController.repeat();
          _playButtonController.forward();
        } else {
          _artworkController.stop();
          _playButtonController.reverse();
        }
      }
    });
  }

  void _updateCurrentSong() {
    final currentSong = _audioService.currentSong;
    if (currentSong != null) {
      setState(() {
        _currentSong = currentSong;
        _songTitle = currentSong.title;
        _artistName = currentSong.artist;
        _albumArt = "assets/images/Music-amico.png"; // Default album art
      });
    }
  }

  @override
  void dispose() {
    _artworkController.dispose();
    _playButtonController.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioService.pause();
      } else {
        if (_audioService.currentSong != null) {
          await _audioService.play();
        } else {
          // If no song is loaded, try to load the first available song
          if (_audioService.songs.isNotEmpty) {
            await _audioService.loadSongByIndex(0);
            await _audioService.play();
            _updateCurrentSong();
          } else {
            // Show message to user
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No songs available. Please add music to your library.',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  void _toggleLoop() {
    setState(() {
      _isLoop = !_isLoop;
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _playPreviousTrack() async {
    try {
      await _audioService.playPrevious();
      _updateCurrentSong();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing previous track: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _playNextTrack() async {
    try {
      await _audioService.playNext();
      _updateCurrentSong();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing next track: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _seekTo(double value) {
    final position = Duration(seconds: value.toInt());
    _audioService.seekTo(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = screenWidth > screenHeight;

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
          child: isLandscape
              ? _buildLandscapeLayout(screenWidth, screenHeight)
              : _buildPortraitLayout(screenWidth, screenHeight),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        backgroundColor: const Color(0xFF4A148C),
        child: const Icon(Icons.home, color: Colors.white),
      ),
    );
  }

  Widget _buildPortraitLayout(double screenWidth, double screenHeight) {
    return Column(
      children: [
        // Header
        _buildHeader(screenWidth),

        const SizedBox(height: 20),

        // Artwork Section
        Expanded(flex: 3, child: _buildArtwork(screenWidth * 0.7)),

        const SizedBox(height: 30),

        // Song Info
        _buildSongInfo(screenWidth),

        const SizedBox(height: 30),

        // Seekbar Section
        _buildSeekbar(screenWidth),

        const SizedBox(height: 40),

        // Playback Controls
        _buildPlaybackControls(screenWidth),

        const SizedBox(height: 30),

        // Extra Controls
        _buildExtraControls(screenWidth),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLandscapeLayout(double screenWidth, double screenHeight) {
    return Row(
      children: [
        // Left side - Artwork and song info
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildHeader(screenWidth * 0.6),
              const SizedBox(height: 20),
              Expanded(child: _buildArtwork(screenHeight * 0.5)),
              const SizedBox(height: 20),
              _buildSongInfo(screenWidth * 0.6),
            ],
          ),
        ),

        // Right side - Controls
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSeekbar(screenWidth * 0.4),
                const SizedBox(height: 40),
                _buildPlaybackControls(screenWidth * 0.4),
                const SizedBox(height: 30),
                _buildExtraControls(screenWidth * 0.4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const Spacer(),
          const Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Show menu
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtwork(double size) {
    return Center(
      child: AnimatedBuilder(
        animation: _artworkAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _artworkAnimation.value * 2 * 3.14159,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.1),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00E5FF),
                    Color(0xFF3F51B5),
                    Color(0xFF9C27B0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size * 0.1),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Placeholder for album art
                    Container(
                      color: Colors.black26,
                      child: Icon(
                        Icons.music_note_rounded,
                        size: size * 0.3,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),

                    // Vinyl record effect
                    Container(
                      width: size * 0.3,
                      height: size * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Container(
                          width: size * 0.1,
                          height: size * 0.1,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSongInfo(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Text(
            _songTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.06,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _artistName,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: width * 0.04,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSeekbar(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF00E5FF),
              inactiveTrackColor: Colors.white.withOpacity(0.2),
              thumbColor: const Color(0xFF00E5FF),
              overlayColor: const Color(0xFF00E5FF).withOpacity(0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _currentPosition.inSeconds.toDouble(),
              max: _totalDuration.inSeconds.toDouble(),
              onChanged: _seekTo,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDuration(_totalDuration),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls(double width) {
    return MusicPlayerControls(
      isPlaying: _isPlaying,
      isShuffleEnabled: _isShuffle,
      isRepeatEnabled: _isLoop,
      onPlayPause: _togglePlayPause,
      onPrevious: () {
        // Previous track logic
        _playPreviousTrack();
      },
      onNext: () {
        // Next track logic
        _playNextTrack();
      },
      onShuffle: _toggleShuffle,
      onRepeat: _toggleLoop,
    );
  }

  Widget _buildExtraControls(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Like
        IconButton(
          onPressed: _toggleLike,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(_isLiked),
              color: _isLiked
                  ? const Color(0xFFE91E63)
                  : Colors.white.withOpacity(0.6),
              size: 24,
            ),
          ),
        ),

        // Lyrics
        IconButton(
          onPressed: () {
            // Show lyrics
            _showLyricsBottomSheet();
          },
          icon: Icon(
            Icons.lyrics_rounded,
            color: Colors.white.withOpacity(0.6),
            size: 24,
          ),
        ),

        // AI Suggest
        IconButton(
          onPressed: () {
            // AI suggestions
            _showAISuggestionsBottomSheet();
          },
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(
                colors: [Color(0xFF00E5FF), Color(0xFF9C27B0)],
              ),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),

        // Share
        IconButton(
          onPressed: () {
            // Share functionality
          },
          icon: Icon(
            Icons.share_rounded,
            color: Colors.white.withOpacity(0.6),
            size: 24,
          ),
        ),
      ],
    );
  }

  void _showLyricsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Color(0xFF0D0D0D)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Lyrics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Lyrics will be displayed here...\n\nAI-powered lyrics sync coming soon!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAISuggestionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Color(0xFF0D0D0D)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.psychology_rounded, color: Color(0xFF00E5FF)),
                  SizedBox(width: 10),
                  Text(
                    'AI Suggestions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'AI-powered music suggestions based on your current listening will appear here...\n\n🎵 Similar tracks\n🎭 Mood-based recommendations\n🎨 Artist collaborations\n📊 Trending in your taste',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
