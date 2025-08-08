import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../models/song_model.dart';

class StorageTestScreen extends StatefulWidget {
  const StorageTestScreen({super.key});

  @override
  State<StorageTestScreen> createState() => _StorageTestScreenState();
}

class _StorageTestScreenState extends State<StorageTestScreen> {
  final AudioService _audioService = AudioService();
  List<Song> _songs = [];
  bool _isLoading = false;
  String _status = 'Ready to test';

  @override
  void initState() {
    super.initState();
    _initializeAudioService();
  }

  Future<void> _initializeAudioService() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing audio service...';
    });

    try {
      await _audioService.initialize();
      setState(() {
        _isLoading = false;
        _status = 'Audio service initialized successfully';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error initializing: $e';
      });
    }
  }

  Future<void> _testScanSystemMusic() async {
    setState(() {
      _isLoading = true;
      _status = 'Scanning system for music files...';
    });

    try {
      final songs = await _audioService.scanSystemMusic();
      setState(() {
        _songs = songs;
        _isLoading = false;
        _status = 'Found ${songs.length} music files';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error scanning: $e';
      });
    }
  }

  Future<void> _testPickMusicFiles() async {
    setState(() {
      _isLoading = true;
      _status = 'Opening file picker...';
    });

    try {
      final songs = await _audioService.pickMusicFiles();
      setState(() {
        _songs = songs;
        _isLoading = false;
        _status = 'Picked ${songs.length} music files';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error picking files: $e';
      });
    }
  }

  Future<void> _testPlaySong(Song song) async {
    setState(() {
      _status = 'Loading song: ${song.title}';
    });

    try {
      await _audioService.loadSong(song);
      await _audioService.play();
      setState(() {
        _status = 'Playing: ${song.title}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error playing song: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'Storage Test',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: const Color(0xFF1A1A1A),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Test Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testScanSystemMusic,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Scan System'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A148C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testPickMusicFiles,
                    icon: const Icon(Icons.file_open),
                    label: const Text('Pick Files'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A148C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Loading Indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF4A148C)),
              ),

            // Results
            if (_songs.isNotEmpty) ...[
              Text(
                'Found Songs (${_songs.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _songs.length,
                  itemBuilder: (context, index) {
                    final song = _songs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: const Color(0xFF1A1A1A),
                      child: ListTile(
                        leading: const Icon(
                          Icons.music_note,
                          color: Color(0xFF4A148C),
                        ),
                        title: Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          song.artist,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        trailing: IconButton(
                          onPressed: () => _testPlaySong(song),
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Color(0xFF4A148C),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
