import 'package:get/get.dart';
import 'package:music_app/controller/audio_controller.dart';
import 'package:music_app/controller/favorites_controller.dart';
import 'package:music_app/controller/theme_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AudioController());
    Get.lazyPut(() => FavoritesController());
    Get.lazyPut(()=> ThemeController());
  }
}
