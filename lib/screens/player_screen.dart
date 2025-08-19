import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:music_app/controller/audio_controller.dart';
import 'package:music_app/controller/favorites_controller.dart';
import 'package:music_app/data/models/local_song_model.dart';
import 'package:music_app/utils/custom_text_style.dart';
import '../widgets/neo_button.dart';

class PlayerScreen extends StatelessWidget {
  final LocalSongModel? song;
  final int? index;

  PlayerScreen({
    super.key,
    this.index,
    this.song,
  });

  final AudioController audioController = Get.find<AudioController>();
  final  favoritesController = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final isPlaying = audioController.isPlaying.value;
          final position = audioController.position.value;
          final duration = audioController.duration.value;
          final currentSong = audioController.currentSong;

          if (currentSong == null) {
            return const Center(child: Text("No song playing"));
          }

          return SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.greenAccent.shade100, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  /// --- HEADER --- ///
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        NeoButton(
                          onPressed: () => Get.back(),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                        ),
                        const Spacer(),
                        Text(
                          'Now Playing',
                          style: myTextStyle12(
                            fontWeight: FontWeight.w600,
                            size: 16,
                            fontColor: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Obx(() {
                          final isFav = favoritesController.isFavorite(currentSong.id);
                          return NeoButton(
                            onPressed: () => favoritesController.toggleFavorite(currentSong.id),
                            child: Icon(
                              Icons.favorite,
                              size: 26,
                              color: isFav ? Colors.red : Colors.white,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// --- ALBUM ART / ANIMATION --- ///
                  Container(
                    height: size.width * 0.75,
                    width: size.width * 0.75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size.width * 0.375),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.375),
                      child: Lottie.asset(
                        "assets/animation/music-new.json",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// --- SONG TITLE & ARTIST --- ///
                  SizedBox(
                    height: 35,
                    child: Marquee(
                      key: ValueKey(currentSong.id),
                      blankSpace: 50,
                      startPadding: 10,
                      velocity: 30,
                      style: myTextStyle12(
                        fontWeight: FontWeight.bold,
                        size: 18,
                        fontColor: Colors.black87,
                      ),
                      text: currentSong.title!.split('/').last,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentSong.artist ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: myTextStyle12(
                      fontColor: Colors.black54,
                      size: 14,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// --- PROGRESS BAR --- ///
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ProgressBar(
                      progress: position,
                      total: duration,
                      progressBarColor: Colors.greenAccent,
                      baseBarColor: Colors.black12,
                      bufferedBarColor: Colors.black26,
                      thumbColor: Colors.greenAccent.shade700,
                      barHeight: 8,
                      thumbRadius: 8,
                      onSeek: (d) => audioController.seek(d),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// --- CONTROLS --- ///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => NeoButton(
                            onPressed: audioController.toggleShuffle,
                            padding: const EdgeInsets.all(14),
                            child: Icon(
                              Icons.shuffle,
                              size: 28,
                              color: audioController.isShuffle.value
                                  ? Colors.greenAccent
                                  : Colors.black54,
                            ),
                          )),
                      NeoButton(
                        onPressed: audioController.previousSong,
                        padding: const EdgeInsets.all(16),
                        child: const Icon(Icons.skip_previous_rounded, size: 36),
                      ),
                      NeoButton(
                        btnBackGroundColor: Colors.greenAccent,
                        onPressed: audioController.togglePlayPause,
                        padding: const EdgeInsets.all(26),
                        isPressed: isPlaying,
                        child: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      NeoButton(
                        onPressed: audioController.nextSong,
                        padding: const EdgeInsets.all(16),
                        child: const Icon(Icons.skip_next_rounded, size: 36),
                      ),
                      Obx(() => NeoButton(
                            onPressed: audioController.toggleRepeat,
                            padding: const EdgeInsets.all(14),
                            child: Icon(
                              Icons.repeat,
                              size: 28,
                              color: audioController.isRepeat.value
                                  ? Colors.greenAccent
                                  : Colors.black54,
                            ),
                          )),
                    ],
                  ),

                  const SizedBox(height: 50),

                  /// --- LYRICS SECTION --- ///
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lyrics",
                          style: myTextStyle12(
                            fontWeight: FontWeight.bold,
                            size: 18,
                            fontColor: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),

                        /// Replace this with actual lyrics from your API
                        Text(
                          currentSong.lyrics ?? "No lyrics available for this song.",
                          style: myTextStyle12(
                            fontColor: Colors.black87,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
