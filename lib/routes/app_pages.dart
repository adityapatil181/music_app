import 'package:get/get.dart';
import 'package:music_app/screens/player_screen.dart';
import 'package:music_app/screens/favorites_view.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:music_app/screens/splash_screen.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: Routes.splash, page: () => SplashView()),
    GetPage(name: Routes.home, page: () => HomeScreen()),
    GetPage(name: Routes.nowPlaying, page: () => PlayerScreen()),
    GetPage(name: Routes.favorites, page: () => FavoritesView()),
    
  ];
}

class Routes {
  static const splash = '/';
  static const home = '/home';
  static const nowPlaying = '/now-playing';
  static const favorites = '/favorites';
  
}
