// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:netshift/controller/netshift_engine_controller.dart';
// import 'package:netshift/controller/stop_watch_controller.dart';
// import 'package:netshift/gen/assets.gen.dart';
// import 'package:netshift/services/windows_local_notif.dart';
// import 'package:tray_manager/tray_manager.dart';
// import 'package:window_manager/window_manager.dart';

// final NetshiftEngineController netshiftEngineController = Get.find();
// final StopWatchController stopWatchController = Get.find();
// Future<void> initializeTray() async {
//   await TrayManager.instance.setIcon(Assets.png.tray);
//   Menu menu = Menu(
//     items: [
//       MenuItem.checkbox(
//         checked: netshiftEngineController.isActive.value,
//         label:
//             netshiftEngineController.isActive.value ? "Disconnect" : "Connect",
//         key: 'connectButton',
//       ),
//       MenuItem.submenu(
//         label: "DNS List",
//         submenu: Menu(
//           items: [
//             for (var item in netshiftEngineController.combinedListDns)
//               MenuItem.checkbox(
//                 key: 'dnsList',
//                 checked: netshiftEngineController.selectedDns.value == item,
//                 label: item.name,
//               )
//           ],
//         ),
//       ),
//       MenuItem.separator(),
//       MenuItem(
//         key: 'show',
//         label: 'Show App',
//       ),
//       MenuItem(
//         key: 'exit',
//         label: 'Exit',
//       ),
//     ],
//   );
//   await TrayManager.instance.setContextMenu(menu);
//   TrayManager.instance.addListener(TrayManagerService());
//   log("Tray initialized successfully.");
//   await TrayManager.instance.setToolTip('NetShift');
// }

// class TrayManagerService implements TrayListener {
//   @override
//   void onTrayIconMouseDown() {
//     windowManager.show();
//   }

//   @override
//   void onTrayIconMouseUp() {}

//   @override
//   void onTrayIconRightMouseDown() {
//     TrayManager.instance.popUpContextMenu();
//   }

//   @override
//   void onTrayIconRightMouseUp() {}

//   @override
//   void onTrayMenuItemClick(MenuItem menuItem) {
//     log("Menu item clicked: ${menuItem.key}");
//     if (menuItem.key == 'connectButton') {
//       if (netshiftEngineController.isActive.value) {
//         netshiftEngineController.stopDnsForWindows();
//         stopWatchController.stopWatchTime();
//         initializeTray();
//         WindowsLocalNotif(
//           body:
//               "NetShift has disconnected from the ${netshiftEngineController.selectedDns.value.name}.",
//           title: "Service Stopped",
//         ).showNotification();
//       } else {
//         netshiftEngineController.startDnsForWindows();
//         stopWatchController.startWatchTime();
//         initializeTray();
//         WindowsLocalNotif(
//           body:
//               "NetShift has successfully connected to the ${netshiftEngineController.selectedDns.value.name}.",
//           title: "Service Started",
//         ).showNotification();
//       }
//       log("Your connection button state is : ${netshiftEngineController.isActive.value.toString()}");
//     } else if (menuItem.key == 'dnsList') {
//       var selectedDns = netshiftEngineController.combinedListDns
//           .firstWhereOrNull((dns) => dns.name == menuItem.label);

//       if (selectedDns != null) {
//         netshiftEngineController.selectedDns.value = selectedDns;
//         netshiftEngineController.saveSelectedDnsValue();
//         log("Selected DNS: ${netshiftEngineController.selectedDns.value.name}");
//         initializeTray();
//       }
//     } else if (menuItem.key == 'show') {
//       windowManager.show();
//     } else if (menuItem.key == 'exit') {
//       TrayManager.instance.destroy();
//       windowManager.close();
//     }
//   }

//   void onTrayIconMouseDoubleClick() {
//     log("Tray icon double-clicked.");
//     windowManager.isVisible().then((isVisible) {
//       if (isVisible) {
//         windowManager.hide();
//       } else {
//         windowManager.show();
//       }
//     });
//   }

//   void onTrayIconRightMouseDoubleClick() {}
// }
