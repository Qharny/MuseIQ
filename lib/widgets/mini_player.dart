import 'package:flutter/material.dart';
import 'package:museiq/models/song_model.dart';
import 'package:museiq/screens/media_player_screen.dart';
import 'package:museiq/services/audio_service.dart';

class MiniPlayer extends StatefulWidget {
  final VoidCallback? onTap;

  const MiniPlayer({Key? key, this.onTap}) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final AudioService _audioService = AudioService();
  bool _isPlaying = false;
  Song? _currentSong;

  @override
  void initState() {
    super.initState();
    _setupAudioService();
  }

  void _setupAudioService() {
    // Listen to player state changes
    _audioService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });

    // Update current song
    _updateCurrentSong();
  }

  void _updateCurrentSong() {
    final currentSong = _audioService.currentSong;
    if (mounted && currentSong != null) {
      setState(() {
        _currentSong = currentSong;
      });
    }
  }

  void _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioService.pause();
      } else {
        if (_audioService.currentSong != null) {
          await _audioService.play();
        } else if (_audioService.songs.isNotEmpty) {
          await _audioService.loadSongByIndex(0);
          await _audioService.play();
          _updateCurrentSong();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't show mini player if no song is loaded
    if (_audioService.songs.isEmpty) {
      return const SizedBox.shrink();
    }

    final song = _currentSong ?? _audioService.songs.first;

    return GestureDetector(
      onTap:
          widget.onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MusicPlayerScreen(),
              ),
            );
          },
      child: Container(
        height: 70,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Album Art
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF4A148C).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.music_note,
                color: Color(0xFF4A148C),
                size: 24,
              ),
            ),

            // Song Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artist,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Play/Pause Button
            IconButton(
              onPressed: _togglePlayPause,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(_isPlaying),
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            // More Options
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MusicPlayerScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
