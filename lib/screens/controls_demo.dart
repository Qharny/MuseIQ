import 'package:flutter/material.dart';
import 'package:museiq/widgets/music_player_controls.dart';

class ControlsDemoScreen extends StatefulWidget {
  const ControlsDemoScreen({Key? key}) : super(key: key);

  @override
  State<ControlsDemoScreen> createState() => _ControlsDemoScreenState();
}

class _ControlsDemoScreenState extends State<ControlsDemoScreen> {
  bool _isPlaying = false;
  bool _isShuffleEnabled = false;
  bool _isRepeatEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Music Controls Demo',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Player Controls
            _buildSection(
              'Full Player Controls',
              'Complete controls with shuffle and repeat',
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MusicPlayerControls(
                  isPlaying: _isPlaying,
                  isShuffleEnabled: _isShuffleEnabled,
                  isRepeatEnabled: _isRepeatEnabled,
                  onPlayPause: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  onPrevious: () {
                    _showMessage('Previous track');
                  },
                  onNext: () {
                    _showMessage('Next track');
                  },
                  onShuffle: () {
                    setState(() {
                      _isShuffleEnabled = !_isShuffleEnabled;
                    });
                  },
                  onRepeat: () {
                    setState(() {
                      _isRepeatEnabled = !_isRepeatEnabled;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Mini Player Controls
            _buildSection(
              'Mini Player Controls',
              'Compact controls for mini player',
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MiniPlayerControls(
                  isPlaying: _isPlaying,
                  onPlayPause: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  onPrevious: () {
                    _showMessage('Previous track');
                  },
                  onNext: () {
                    _showMessage('Next track');
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Floating Controls
            _buildSection(
              'Floating Controls',
              'Overlay controls for floating player',
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: FloatingPlayerControls(
                    isPlaying: _isPlaying,
                    onPlayPause: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    onPrevious: () {
                      _showMessage('Previous track');
                    },
                    onNext: () {
                      _showMessage('Next track');
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Control States Demo
            _buildSection(
              'Control States',
              'Different states of the controls',
              Column(
                children: [
                  _buildStateDemo('Playing State', true),
                  const SizedBox(height: 16),
                  _buildStateDemo('Paused State', false),
                  const SizedBox(height: 16),
                  _buildStateDemo(
                    'With Shuffle Enabled',
                    false,
                    shuffleEnabled: true,
                  ),
                  const SizedBox(height: 16),
                  _buildStateDemo(
                    'With Repeat Enabled',
                    false,
                    repeatEnabled: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildStateDemo(
    String title,
    bool isPlaying, {
    bool shuffleEnabled = false,
    bool repeatEnabled = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          MusicPlayerControls(
            isPlaying: isPlaying,
            isShuffleEnabled: shuffleEnabled,
            isRepeatEnabled: repeatEnabled,
            onPlayPause: () {
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
            onPrevious: () {
              _showMessage('Previous track');
            },
            onNext: () {
              _showMessage('Next track');
            },
            onShuffle: () {
              setState(() {
                _isShuffleEnabled = !_isShuffleEnabled;
              });
            },
            onRepeat: () {
              setState(() {
                _isRepeatEnabled = !_isRepeatEnabled;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF4A148C),
      ),
    );
  }
}
