import 'package:dns_changer/theme/theme_provider.dart';
import 'package:dns_changer/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      windowButtonVisibility: false,
      size: Size(400, 660),
      center: true,
      title: "DNS Changer");

  await windowManager.waitUntilReadyToShow(windowOptions).then((_) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
