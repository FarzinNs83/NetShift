import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netshift/controller/theme_controller.dart';

class SystemChromeController {
  final ThemeController themeController = Get.put(ThemeController());
  void setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: themeController.isDarkMode
            ? const Color(0xFF1A1B21)
            : const Color.fromARGB(255, 231, 218, 250),
        statusBarIconBrightness: themeController.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: themeController.isDarkMode
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarIconBrightness: themeController.isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }
}
