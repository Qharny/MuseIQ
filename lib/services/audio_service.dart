import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import '../models/song_model.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _songs = [];
  int _currentIndex = -1;
  bool _isInitialized = false;

  // Getters
  AudioPlayer get player => _audioPlayer;
  List<Song> get songs => List.unmodifiable(_songs);
  Song? get currentSong => _currentIndex >= 0 && _currentIndex < _songs.length
      ? _songs[_currentIndex]
      : null;
  int get currentIndex => _currentIndex;
  bool get isInitialized => _isInitialized;

  // Streams
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration?> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get bufferedPositionStream =>
      _audioPlayer.bufferedPositionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request storage/media permissions
      await _requestPermissions();
      _isInitialized = true;
    } catch (e) {
      print('Error initializing AudioService: $e');
      rethrow;
    }
  }

  // Request necessary permissions
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      // On Android 13+ storage permission is split into media-specific ones.
      // Try requesting audio/media first, then fall back to legacy storage
      // on older Android versions.
      PermissionStatus audioStatus = PermissionStatus.denied;
      PermissionStatus storageStatus = PermissionStatus.denied;

      // Request audio/media permission (READ_MEDIA_AUDIO on Android 13+)
      try {
        audioStatus = await Permission.audio.request();
      } catch (_) {
        // Some devices/older plugin versions might not support this; ignore.
      }

      if (audioStatus.isGranted) {
        return;
      }

      // Fallback: legacy external storage (READ_EXTERNAL_STORAGE) for <= Android 12
      try {
        storageStatus = await Permission.storage.request();
      } catch (_) {}

      if (storageStatus.isGranted) {
        return;
      }

      // If both denied or permanently denied, surface a clear error
      if (audioStatus.isPermanentlyDenied ||
          storageStatus.isPermanentlyDenied) {
        throw Exception(
          'Permission permanently denied. Enable "Music and audio" (or Storage) in system Settings > Apps > MuseIQ > Permissions.',
        );
      }

      throw Exception(
        'Audio/Storage permission is required to access music files',
      );
    }
  }

  // Scan for music files in system storage
  Future<List<Song>> scanSystemMusic() async {
    if (!_isInitialized) await initialize();

    List<Song> foundSongs = [];

    try {
      if (Platform.isAndroid) {
        // Common music directories on Android
        final directories = [
          '/storage/emulated/0/Music',
          '/storage/emulated/0/Download',
          '/storage/emulated/0/DCIM',
          '/storage/emulated/0/Pictures',
        ];

        for (String dirPath in directories) {
          final directory = Directory(dirPath);
          if (await directory.exists()) {
            final songs = await _scanDirectory(directory);
            foundSongs.addAll(songs);
          }
        }
      } else if (Platform.isIOS) {
        // For iOS, we'll use file picker since direct file system access is limited
        // This will be handled in pickMusicFiles()
        return [];
      }

      _songs = foundSongs;
      return foundSongs;
    } catch (e) {
      print('Error scanning system music: $e');
      return [];
    }
  }

  // Scan a specific directory for music files
  Future<List<Song>> _scanDirectory(Directory directory) async {
    List<Song> songs = [];

    try {
      await for (FileSystemEntity entity in directory.list(recursive: true)) {
        if (entity is File) {
          final extension = path.extension(entity.path).toLowerCase();
          if (_isAudioFile(extension)) {
            try {
              final song = await _createSongFromFile(entity);
              if (song != null) {
                songs.add(song);
              }
            } catch (e) {
              print('Error processing file ${entity.path}: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Error scanning directory ${directory.path}: $e');
    }

    return songs;
  }

  // Check if file is an audio file
  bool _isAudioFile(String extension) {
    const audioExtensions = [
      '.mp3',
      '.wav',
      '.aac',
      '.m4a',
      '.flac',
      '.ogg',
      '.wma',
      '.opus',
    ];
    return audioExtensions.contains(extension);
  }

  // Create a Song object from a file
  Future<Song?> _createSongFromFile(File file) async {
    try {
      final fileName = path.basenameWithoutExtension(file.path);

      // Basic song creation with file info
      final song = Song(
        id: file.path.hashCode.toString(),
        title: fileName,
        artist: 'Unknown Artist',
        album: 'Unknown Album',
        duration: Duration.zero, // Will be updated when loaded
        filePath: file.path,
        isLocalFile: true,
      );

      return song;
    } catch (e) {
      print('Error creating song from file ${file.path}: $e');
      return null;
    }
  }

  // Pick music files using file picker
  Future<List<Song>> pickMusicFiles() async {
    if (!_isInitialized) await initialize();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
        withData: false,
      );

      if (result != null) {
        List<Song> pickedSongs = [];

        for (final file in result.files) {
          if (file.path != null) {
            final song = await _createSongFromFile(File(file.path!));
            if (song != null) {
              pickedSongs.add(song);
            }
          }
        }

        _songs.addAll(pickedSongs);
        return pickedSongs;
      }
    } catch (e) {
      print('Error picking music files: $e');
    }

    return [];
  }

  // Load and play a song
  Future<void> loadSong(Song song) async {
    try {
      await _audioPlayer.setFilePath(song.filePath);
      _currentIndex = _songs.indexOf(song);
    } catch (e) {
      print('Error loading song: $e');
      rethrow;
    }
  }

  // Load and play a song by index
  Future<void> loadSongByIndex(int index) async {
    if (index >= 0 && index < _songs.length) {
      await loadSong(_songs[index]);
    }
  }

  // Play the current song
  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing song: $e');
      rethrow;
    }
  }

  // Pause the current song
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing song: $e');
      rethrow;
    }
  }

  // Stop the current song
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping song: $e');
      rethrow;
    }
  }

  // Seek to a specific position
  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking: $e');
      rethrow;
    }
  }

  // Play next song
  Future<void> playNext() async {
    if (_songs.isEmpty) return;

    int nextIndex = (_currentIndex + 1) % _songs.length;
    await loadSongByIndex(nextIndex);
    await play();
  }

  // Play previous song
  Future<void> playPrevious() async {
    if (_songs.isEmpty) return;

    int prevIndex = _currentIndex <= 0 ? _songs.length - 1 : _currentIndex - 1;
    await loadSongByIndex(prevIndex);
    await play();
  }

  // Set volume
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      print('Error setting volume: $e');
      rethrow;
    }
  }

  // Get current position
  Duration? get currentPosition => _audioPlayer.position;

  // Get current duration
  Duration? get currentDuration => _audioPlayer.duration;

  // Check if currently playing
  bool get isPlaying => _audioPlayer.playing;

  // Dispose resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _songs.clear();
    _currentIndex = -1;
    _isInitialized = false;
  }

  // Clear all songs
  void clearSongs() {
    _songs.clear();
    _currentIndex = -1;
  }

  // Add songs to the playlist
  void addSongs(List<Song> songs) {
    _songs.addAll(songs);
  }

  // Remove a song from the playlist
  void removeSong(Song song) {
    final index = _songs.indexOf(song);
    if (index != -1) {
      _songs.removeAt(index);
      if (_currentIndex >= _songs.length) {
        _currentIndex = _songs.length - 1;
      }
    }
  }
}
