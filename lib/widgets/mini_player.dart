import 'package:flutter/material.dart';
import 'package:museiq/screens/media_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  final bool isPlaying;
  final String songTitle;
  final String artistName;
  final VoidCallback? onTap;

  const MiniPlayer({
    Key? key,
    this.isPlaying = false,
    this.songTitle = 'No song playing',
    this.artistName = 'Unknown Artist',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
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
                    songTitle,
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
                    artistName,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Play/Pause Button
            IconButton(
              onPressed: () {
                // Toggle play/pause
                if (onTap != null) {
                  onTap!();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MusicPlayerScreen(),
                    ),
                  );
                }
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(isPlaying),
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
