import 'package:flutter/material.dart';

class MusicPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onShuffle;
  final VoidCallback? onRepeat;
  final bool isShuffleEnabled;
  final bool isRepeatEnabled;
  final double size;

  const MusicPlayerControls({
    Key? key,
    this.isPlaying = false,
    this.onPlayPause,
    this.onNext,
    this.onPrevious,
    this.onShuffle,
    this.onRepeat,
    this.isShuffleEnabled = false,
    this.isRepeatEnabled = false,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Shuffle Button
        IconButton(
          onPressed: onShuffle,
          icon: Icon(
            Icons.shuffle_rounded,
            color: isShuffleEnabled
                ? const Color(0xFF00E5FF)
                : Colors.white.withOpacity(0.6),
            size: 24,
          ),
        ),

        // Previous Button
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(
            Icons.skip_previous_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),

        // Play/Pause Button (Large)
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF00E5FF), Color(0xFF3F51B5)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPlayPause,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                key: ValueKey(isPlaying),
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),

        // Next Button
        IconButton(
          onPressed: onNext,
          icon: const Icon(
            Icons.skip_next_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),

        // Repeat Button
        IconButton(
          onPressed: onRepeat,
          icon: Icon(
            Icons.repeat_rounded,
            color: isRepeatEnabled
                ? const Color(0xFF00E5FF)
                : Colors.white.withOpacity(0.6),
            size: 24,
          ),
        ),
      ],
    );
  }
}

// Mini Player Controls (for use in mini player)
class MiniPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const MiniPlayerControls({
    Key? key,
    this.isPlaying = false,
    this.onPlayPause,
    this.onNext,
    this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous Button
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(
            Icons.skip_previous_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),

        // Play/Pause Button
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4A148C),
          ),
          child: IconButton(
            onPressed: onPlayPause,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                key: ValueKey(isPlaying),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),

        // Next Button
        IconButton(
          onPressed: onNext,
          icon: const Icon(
            Icons.skip_next_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}

// Floating Controls (for overlay or floating player)
class FloatingPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const FloatingPlayerControls({
    Key? key,
    this.isPlaying = false,
    this.onPlayPause,
    this.onNext,
    this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Previous Button
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(
              Icons.skip_previous_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          // Play/Pause Button
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4A148C),
            ),
            child: IconButton(
              onPressed: onPlayPause,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(isPlaying),
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // Next Button
          IconButton(
            onPressed: onNext,
            icon: const Icon(
              Icons.skip_next_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
