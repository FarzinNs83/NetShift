import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initTray() async {
  await TrayManager.instance.setIcon('assets/images/tray.ico');

  List<MenuItem> items = [
    MenuItem(
      key: 'show',
      label: 'Show App',
    ),
    MenuItem(
      key: 'exit',
      label: 'Exit',
    ),
  ];

  await TrayManager.instance.setContextMenu(Menu(items: items));

  TrayManager.instance.addListener(MyTrayListener());
  debugPrint("Tray initialized successfully.");
}

class MyTrayListener implements TrayListener {
  @override
  void onTrayIconMouseDown() {
    windowManager.show();
  }

  @override
  void onTrayIconMouseUp() {}

  @override
  void onTrayIconRightMouseDown() {
    TrayManager.instance.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {}

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    debugPrint("Menu item clicked: ${menuItem.key}");
    switch (menuItem.key) {
      case 'show':
        windowManager.show();
        break;
      case 'exit':
        windowManager.close();
    }
  }

  void onTrayIconMouseDoubleClick() {
    debugPrint("Tray icon double-clicked.");
    windowManager.isVisible().then((isVisible) {
      if (isVisible) {
        windowManager.hide();
      } else {
        windowManager.show();
      }
    });
  }

  void onTrayIconRightMouseDoubleClick() {}
}
