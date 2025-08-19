import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/local_song_model.dart';
import 'audio_controller.dart';

class FavoritesController extends GetxController {
  static FavoritesController get to => Get.find<FavoritesController>();

  var favoriteSongIds = <int>[].obs; 

  @override
  void onInit() {
    super.onInit();
    _loadFavorites(); 
  }

  /// Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? ids = prefs.getStringList('favoriteSongIds');
      if (ids != null) {
        favoriteSongIds.value = ids.map(int.parse).toList();
      }
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }
  }

  /// Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = favoriteSongIds.map((e) => e.toString()).toList();
      await prefs.setStringList('favoriteSongIds', ids);
    } catch (e) {
      debugPrint("Error saving favorites: $e");
    }
  }

  /// Check if a song is favorite
  bool isFavorite(int? songId) {
    if (songId == null) return false;
    return favoriteSongIds.contains(songId);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(int? songId) async {
    if (songId == null) return;

    if (favoriteSongIds.contains(songId)) {
      favoriteSongIds.remove(songId);
    } else {
      favoriteSongIds.add(songId);
    }

    await _saveFavorites(); 
  }

  /// Get favorite songs from AudioController
  List<LocalSongModel> get favoriteSongs {
    final audioController = AudioController.to;
    return audioController.songs
        .where((song) => favoriteSongIds.contains(song.id))
        .toList();
  }
}
