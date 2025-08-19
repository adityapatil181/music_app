class LocalSongModel {
  final int? id;
  final String? title;
   String? artist;
  final String? uri;
  final String? albumArt;
  final int? duration;
  final String? lyrics;

  LocalSongModel({
     this.id,
     this.title,
     this.artist,
     this.uri,
     this.albumArt,
     this.duration,
     this.lyrics,
  });
}