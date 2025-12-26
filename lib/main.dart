import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:netshift/binding.dart';
import 'package:netshift/controller/system_chrome_controller.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/theme_controller.dart';
import 'package:netshift/screens/splash_screen.dart';
import 'package:netshift/core/services/tray_manager_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

Future<void> main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  InitialBindings().dependencies();

  // Only lock orientation on mobile platforms
  if (Platform.isAndroid || Platform.isIOS) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  await GetStorage.init();

  // WINDOWS
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      backgroundColor: Colors.transparent,
      size: Size(480, 770),
      center: true,
      title: "NetShift",
    );
    await windowManager.waitUntilReadyToShow(windowOptions).then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.show();
      await windowManager.focus();
    });
    await WindowsSingleInstance.ensureSingleInstance(
      arguments,
      "Change this when you want to use this app",
      // ignore: avoid_print
      onSecondWindow: (arguments) => print(arguments),
    );
    await initTray();
    await localNotifier.setup(
      appName: "NetShift",
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  // MACOS
  if (Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      backgroundColor: Colors.transparent,
      size: Size(1000, 700),
      minimumSize: Size(800, 600),
      center: true,
      title: "NetShift",
      titleBarStyle: TitleBarStyle.hidden,
    );
    await windowManager.waitUntilReadyToShow(windowOptions).then((_) async {
      await windowManager.show();
      await windowManager.focus();
    });
    await initTray();
    await localNotifier.setup(
      appName: "NetShift",
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  SystemChromeController().setSystemUIOverlayStyle();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ananas = Get.put(ThemeController());
    ScreenSize().init(context);
    return GetMaterialApp(
      theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(ananas.isDarkMode
            ? Colors.greenAccent.withValues(alpha: 0.6)
            : Colors.indigo.withValues(alpha: 0.6)),
        trackColor: WidgetStateProperty.all(
            ananas.isDarkMode ? Colors.black : Colors.grey),
      )),
      initialBinding: InitialBindings(),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
