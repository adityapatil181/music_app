import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/themes/app_theme.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  /// Toggle between light and dark themes
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  
  ThemeData get themeData => isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme;
}
