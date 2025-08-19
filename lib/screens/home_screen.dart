import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/controller/audio_controller.dart';
import 'package:music_app/controller/theme_controller.dart';
import 'package:music_app/screens/favorites_view.dart';
import 'package:music_app/screens/player_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final audioController = Get.put(AudioController());
  final themeController = Get.put(ThemeController());

  // 🔎 Search query (reactive string)
  final RxString searchQuery = ''.obs;

  String _formatDuration(int milliseconds) {
    final minutes = (milliseconds / 60000).floor();
    final seconds = ((milliseconds % 60000) / 1000).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('My Music', style: TextStyle(color: Colors.white)),
        actions: [
          // Favorites button
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {
              Get.to(() => FavoritesView());
            },
          ),
          // Theme toggle button
          Obx(() {
            return IconButton(
              icon: Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () {
                themeController.toggleTheme();
              },
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // 🔎 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => searchQuery.value = value.toLowerCase(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search songs...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Obx(() => searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () => searchQuery.value = "",
                      )
                    : const SizedBox.shrink()),
              ),
            ),
          ),

          // 🎵 Song List
          Expanded(
            child: Obx(() {
              if (!audioController.hasPermission.value) {
                return const Center(
                  child: Text(
                    'Permission required to access music files',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              if (audioController.songs.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Filter songs by search
              final filteredSongs = audioController.songs.where((song) {
                final title = song.title?.toLowerCase() ?? "";
                final artist = song.artist?.toLowerCase() ?? "";
                return title.contains(searchQuery.value) ||
                    artist.contains(searchQuery.value);
              }).toList();

              if (filteredSongs.isEmpty) {
                return const Center(
                  child: Text(
                    "No songs found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  final song = filteredSongs[index];
                  final isCurrent =
                      audioController.currentIndex.value == index;
                  final isPlaying = audioController.isPlaying.value;

                  return GestureDetector(
                    onTap: () async {
                      await audioController.playSong(
                          audioController.songs.indexOf(song));
                      Get.to(() => PlayerScreen(
                          song: song,
                          index: audioController.songs.indexOf(song)));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? Colors.greenAccent.withOpacity(0.2)
                            : Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Album Art
                          const Icon(Icons.music_note,
                              size: 50, color: Colors.white54),

                          const SizedBox(width: 12),

                          // Song details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  song.artist ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          // Duration & Play/Pause
                          Column(
                            children: [
                              Text(
                                _formatDuration(song.duration!),
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              IconButton(
                                icon: Icon(
                                  isCurrent && isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                  color: Colors.greenAccent,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  if (isCurrent && isPlaying) {
                                    audioController.togglePlayPause();
                                  } else {
                                    await audioController.playSong(
                                        audioController.songs.indexOf(song));
                                    Get.to(() => PlayerScreen(
                                        song: song,
                                        index: audioController.songs
                                            .indexOf(song)));
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
