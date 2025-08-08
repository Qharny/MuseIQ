class Song {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String? albumArt;
  final Duration duration;
  final String filePath;
  final bool isLocalFile;
  final String? genre;
  final int? year;
  final int? trackNumber;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.albumArt,
    required this.duration,
    required this.filePath,
    this.isLocalFile = true,
    this.genre,
    this.year,
    this.trackNumber,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'] ?? '',
      title: map['title'] ?? 'Unknown Title',
      artist: map['artist'] ?? 'Unknown Artist',
      album: map['album'],
      albumArt: map['albumArt'],
      duration: Duration(milliseconds: map['duration'] ?? 0),
      filePath: map['filePath'] ?? '',
      isLocalFile: map['isLocalFile'] ?? true,
      genre: map['genre'],
      year: map['year'],
      trackNumber: map['trackNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'albumArt': albumArt,
      'duration': duration.inMilliseconds,
      'filePath': filePath,
      'isLocalFile': isLocalFile,
      'genre': genre,
      'year': year,
      'trackNumber': trackNumber,
    };
  }

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? albumArt,
    Duration? duration,
    String? filePath,
    bool? isLocalFile,
    String? genre,
    int? year,
    int? trackNumber,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArt: albumArt ?? this.albumArt,
      duration: duration ?? this.duration,
      filePath: filePath ?? this.filePath,
      isLocalFile: isLocalFile ?? this.isLocalFile,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      trackNumber: trackNumber ?? this.trackNumber,
    );
  }

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist, album: $album, duration: $duration, filePath: $filePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}