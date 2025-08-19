import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/binding/app_binding.dart';
import 'package:music_app/controller/audio_controller.dart';
import 'package:music_app/controller/favorites_controller.dart';
import 'package:music_app/controller/theme_controller.dart';
import 'package:music_app/routes/app_pages.dart';
import 'package:music_app/themes/app_theme.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // await requestPermissions();

  runApp(MyApp());
}


// Future<void> requestPermissions() async {
//   final OnAudioQuery audioQuery = OnAudioQuery();

//   bool permissionStatus = await audioQuery.permissionsStatus();
//   if (!permissionStatus) {
//     await audioQuery.permissionsRequest();
//   }
// }
class MyApp extends StatelessWidget {
    final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      title: "Local Music Player",
      theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
