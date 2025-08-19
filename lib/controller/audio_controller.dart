import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/models/local_song_model.dart';
import 'package:music_app/data/repository/music_api_helper.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioController extends GetxController {
  static AudioController get to => Get.find<AudioController>();

  final AudioPlayer audioPlayer = AudioPlayer();
  final OnAudioQuery audioQuery = OnAudioQuery();

  
  var songs = <LocalSongModel>[].obs;
  var currentIndex = (-1).obs;
  var isPlaying = false.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  var hasPermission = false.obs;
  var isShuffle = false.obs;
  var isRepeat = false.obs;

 
  var lyrics = "".obs;

  LocalSongModel? get currentSong =>
      currentIndex.value != -1 && currentIndex.value < songs.length
          ? songs[currentIndex.value]
          : null;

  @override
  void onInit() {
    super.onInit();
    _setupAudioPlayer();
    loadSongsWithPermission();
  }

  // AUDIO PLAYER SETUP 
  void _setupAudioPlayer() {
    print('_setupAudioPlayerrrrr');
    audioPlayer.playerStateStream.listen((playerState) async {
      isPlaying.value = playerState.playing;

      if (playerState.processingState == ProcessingState.completed) {
        if (isRepeat.value && currentIndex.value != -1) {
          await Future.delayed(const Duration(milliseconds: 200));
          playSong(currentIndex.value); // repeat current
        } else {
          await Future.delayed(const Duration(milliseconds: 200));
          nextSong(); // go to next (shuffle/normal)
        }
      }
    });

    audioPlayer.positionStream.listen((pos) => position.value = pos);
    audioPlayer.durationStream.listen((dur) {
      if (dur != null) duration.value = dur;
    });
  }

  //  SONG LOADING
  Future<void> loadSongsWithPermission() async {
    print('loadSongsWithPermissionnnn');
    try {
      final permission = await Permission.audio.status;
      if (permission.isGranted) {
        hasPermission.value = true;
        await loadSongs();
      } else {
        final result = await Permission.audio.request();
        hasPermission.value = result.isGranted;
        if (result.isGranted) await loadSongs();
      }
    } catch (e) {
      debugPrint('Permission error: $e');
      hasPermission.value = false;
    }
  }

  Future<void> loadSongs() async {
    print('loadSongssssss');
    try {
      final fetchedSongs = await audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      songs.value = fetchedSongs
          .where((song) => song.uri != null && song.uri!.isNotEmpty)
          .map((song) => LocalSongModel(
                id: song.id,
                title: song.title,
                artist: song.artist ?? 'Unknown Artist',
                uri: song.uri ?? '',
                albumArt: song.album ?? '',
                duration: song.duration ?? 0,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error loading songs: $e');
    }
  }

  //  LYRICS FETCHING 
  Future<void> fetchLyricsForCurrentSong({String? artistName}) async {
    print('fetchLyricsForCurrentSongggg');
    final song = currentSong;
    if (song == null) return;

    // Use static artist if none exists
    final artist = artistName ?? song.artist ?? 'Unknown';
    final title = song.title ?? '';

    lyrics.value = "Loading lyrics...";
    final fetchedLyrics = await MusicApiHelper.fetchLyrics(
      artist: artist,
      title: title,
    );
    lyrics.value = fetchedLyrics;
  }

  //  PLAYBACK CONTROLS 
  Future<void> playSong(int index) async {
     print('playSonggggggggggg');
    if (index < 0 || index >= songs.length) return;
    final song = songs[index];

    if (song.uri!.isEmpty) {
      debugPrint("Cannot play song: URI is empty for ${song.title}");
      return;
    }

    try {
      await audioPlayer.stop();
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
      await audioPlayer.play();
      currentIndex.value = index;
      isPlaying.value = true;

      // Fetch lyrics when a new song starts
      fetchLyricsForCurrentSong();
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  Future<void> pauseSong() async {
 print('pauseSonggggggggg');
    try {
      await audioPlayer.pause();
      isPlaying.value = false;
    } catch (e) {
      debugPrint('Pause error: $e');
    }
  }

  Future<void> resumeSong() async {
     print('resumeSongggggg');
    
    try {
      await audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      debugPrint('Resume error: $e');
    }
  }

  void togglePlayPause() async {
     print('togglePlayPauseeeeeee');
    if (currentIndex.value == -1) return;
    if (isPlaying.value) {
      await pauseSong();
    } else {
      await resumeSong();
    }
  }

  Future<void> nextSong() async {
     print('nextSonggggggg');
    if (songs.isEmpty) return;

    int nextIndex;
    if (isShuffle.value) {
      final random = Random();
      do {
        nextIndex = random.nextInt(songs.length);
      } while (nextIndex == currentIndex.value && songs.length > 1);
    } else {
      nextIndex = currentIndex.value < songs.length - 1
          ? currentIndex.value + 1
          : 0;
    }

    await playSong(nextIndex);
  }

  Future<void> previousSong() async {
     print('previousSongggggggg');
    if (songs.isEmpty) return;

    int prevIndex;
    if (isShuffle.value) {
      final random = Random();
      do {
        prevIndex = random.nextInt(songs.length);
      } while (prevIndex == currentIndex.value && songs.length > 1);
    } else {
      prevIndex = currentIndex.value > 0
          ? currentIndex.value - 1
          : songs.length - 1;
    }

    await playSong(prevIndex);
  }

  Future<void> seek(Duration pos) async {
    try {
      await audioPlayer.seek(pos);
    } catch (e) {
      debugPrint('Seek error: $e');
    }
  }

  //  TOGGLES 
  void toggleShuffle() => isShuffle.value = !isShuffle.value;
  void toggleRepeat() => isRepeat.value = !isRepeat.value;

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
