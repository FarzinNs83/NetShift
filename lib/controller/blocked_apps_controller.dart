import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class BlockedAppsController extends GetxController {
  final GetStorage box2 = GetStorage();
  RxList<String> blockedApps = <String>[].obs;
  RxList<AppInfo> apps = <AppInfo>[].obs;
  RxBool isSystemApp = false.obs;
  @override
  void onInit() {
    super.onInit();
    loadSystemAppState();
    loadBlockedAppsList();
  }

  Future<void> installedApps() async {
    try {
      final result = await InstalledApps.getInstalledApps(
        excludeSystemApps: !isSystemApp.value,
        withIcon: true,
      );
      apps.addAll(result);
      apps.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      log("Error fetching installed apps: $e");
    }
  }

  void saveSystemAppState() {
    box2.write('isSystemApp', isSystemApp.value);
  }

  void loadSystemAppState() {
    isSystemApp.value = box2.read('isSystemApp') ?? false;
    log("Your system app state is : ${isSystemApp.value.toString()}");
  }

  void saveBlockedAppsList() {
    box2.write('blockedAppsList', blockedApps.toList());
    log("Your blocked apps list is : ${blockedApps.toString()}");
  }

  void loadBlockedAppsList() {
    List<String> sortedBlockedApps =
        box2.read('blockedAppsList')?.cast<String>() ?? [];
    blockedApps.value = sortedBlockedApps;
    log("Your blocked app lists are : ${blockedApps.toString()}");
  }
}
