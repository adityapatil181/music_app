import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/controller/favorites_controller.dart';
import '../../../routes/app_pages.dart';
import '../controller/audio_controller.dart';

class FavoritesView extends StatelessWidget {
  final AudioController audioController = Get.find<AudioController>();
 final   favoritesController = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        final favoriteSongs = favoritesController.favoriteSongs;
        if (favoriteSongs.isEmpty) {
          return const Center(child: Text("No favorites added yet."));
        }

        return ListView.builder(
          itemCount: favoriteSongs.length,
          itemBuilder: (context, index) {
            final song = favoriteSongs[index];

            return ListTile(
              leading: const Icon(Icons.music_note),
              title: Text(song.title ?? ''),
              subtitle: Text(song.artist ?? ''),
              trailing: Obx(() {
                final isFav = favoritesController.isFavorite(song.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => favoritesController.toggleFavorite(song.id),
                );
              }),
              onTap: () async {
                // Play the song using AudioController
                final indexInAllSongs = audioController.songs
                    .indexWhere((s) => s.id == song.id);
                if (indexInAllSongs != -1) {
                  await audioController.playSong(indexInAllSongs);
                  // Navigate to NowPlaying screen with the song
                  Get.toNamed(Routes.nowPlaying, arguments: song);
                }
              },
            );
          },
        );
      }),
    );
  }
}
