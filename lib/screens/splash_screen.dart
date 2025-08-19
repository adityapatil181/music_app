import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    Future.delayed(Duration(seconds: 3), () {
      Get.offNamed(Routes.home);
    });

    return Scaffold(
      body: Center(
        child: Text(
          "Local Music Player",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
